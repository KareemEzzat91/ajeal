import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:ajeal/admin/models/goals_model/goals.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ScheduleGeneratorService {
  static final ScheduleGeneratorService _generateSchedule =
      ScheduleGeneratorService._internal();

  factory ScheduleGeneratorService() {
    return _generateSchedule;
  }

  ScheduleGeneratorService._internal();

  // Main method that doesn't rely on Gemini API
  Future<List<Map<String, dynamic>>> generateScheduleLocally({
    required DateTime startDate,
    required DateTime endDate,
    required String childName,
    required List<Goal> goalsList,
  }) async {
    // Validate inputs
    final durationInDays = endDate.difference(startDate).inDays;
    if (durationInDays <= 0) {
      throw ArgumentError('End date must be after start date');
    }
    if (goalsList.isEmpty) {
      throw ArgumentError('At least one goal must be provided');
    }

    // Calculate session dates (3 sessions per week, every 3 days)
    final List<DateTime> sessionDates = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      sessionDates.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 3));
    }

    // Create a random number generator with a fixed seed for consistent results
    final random = Random(childName.hashCode);

    // Distribute goals across sessions using a smart algorithm
    final List<Map<String, dynamic>> sessions = [];
    int sessionNumber = 1;

    for (int i = 0; i < sessionDates.length; i++) {
      // Determine how many goals per session (2-3)
      final goalsPerSession = random.nextInt(2) + 2; // Either 2 or 3 goals

      // Shuffle goals to create variety but maintain coverage
      final shuffledGoals = List<Goal>.from(goalsList)..shuffle(random);

      // Select goals for this session using a weighted approach
      // Earlier goals in the shuffled list have higher priority
      final List<String> sessionGoals = [];
      for (int j = 0; j < goalsPerSession && j < shuffledGoals.length; j++) {
        sessionGoals.add(shuffledGoals[j].goalName);
      }

      // Create session object
      sessions.add({
        "session": sessionNumber++,
        "date": _formatDate(sessionDates[i]),
        "goals": sessionGoals,
        "rate": 0,
        "notes": "",
        "tasks": [],
        "completed": false,
      });
    }

    return sessions;
  }

  // Method that tries Gemini first, then falls back to local generation
  Future<List<Map<String, dynamic>>> generateScheduleWithFallback({
    required DateTime startDate,
    required DateTime endDate,
    required String duration,
    required String childName,
    required List<Goal> goalsList,
  }) async {
    try {
      // First try using Gemini API (your existing method)
      return await generateSchedule(
          startDate: startDate,
          endDate: endDate,
          duration: duration,
          childName: childName,
          goalsList: goalsList);
    } catch (e) {
      // Log the error

      // Use local generation instead
      return await generateScheduleLocally(
        startDate: startDate,
        endDate: endDate,
        childName: childName,
        goalsList: goalsList,
      );
    }
  }

  Future<List<Map<String, dynamic>>> generateSchedule({
    required DateTime startDate,
    required DateTime endDate,
    required String duration,
    required String childName,
    required List<Goal> goalsList,
  }) async {
    // Extract goal information
    final List<String> goals = goalsList.map((goal) => goal.goalName).toList();
    // Calculate duration and validate inputs
    final durationInDays = endDate.difference(startDate).inDays;
    if (durationInDays <= 0) {
      throw ArgumentError('End date must be after start date');
    }
    if (goalsList.isEmpty) {
      throw ArgumentError('At least one goal must be provided');
    }

    // Construct a more concise prompt to reduce token usage
    final prompt = '''
Create a therapy schedule for **$childName** from ${_formatDate(startDate)} to ${_formatDate(endDate)} with these goals:
${_formatGoalsList(goals)}

Requirements:
- 3 sessions per week, every 3 days
- Distribute goals evenly across sessions
- Return in JSON format:
```json
{
  "weeks": [
    {
      "session": 1,
      "date": "YYYY-MM-DD",
      "goals": ["هدف 1", "هدف 2"]
    }
  ]
}
```
''';

    final gemini = Gemini.instance;
    int retryCount = 0;
    const maxRetries = 3;
    const baseDelay = 2000; // 2 seconds

    while (retryCount < maxRetries) {
      try {
        // Make API request with timeout
        final response = await gemini.prompt(parts: [Part.text(prompt)]).timeout(
              const Duration(seconds: 130),
              onTimeout: () =>
                  throw TimeoutException('Gemini API request timed out'),
            );

        if (response == null ||
            response.output == null ||
            response.output!.isEmpty) {
          throw Exception('Empty response from Gemini API');
        }

        String rawResponse = response.output!;
        return _parseScheduleResponse(rawResponse);
      } on Exception catch (e) {
        final errorMessage = e.toString().toLowerCase();

        // Check specifically for rate limit errors (429)
        if (errorMessage.contains('429') ||
            errorMessage.contains('too many requests')) {
          retryCount++;
          if (retryCount >= maxRetries) {
            _logError(
                'Rate limit exceeded', 'Max retries reached after 429 error');
            throw Exception('Rate limit exceeded. Please try again later.');
          }

          // Exponential backoff with jitter
          final delay = baseDelay * pow(2, retryCount) + Random().nextInt(1000);
          _logError('Rate limit',
              'Received 429 error, retrying in ${delay}ms (attempt $retryCount of $maxRetries)');

          await Future.delayed(Duration(milliseconds: delay.toInt()));
          continue; // Retry the request
        }

        // Handle other errors
        if (e is TimeoutException) {
          _logError('API timeout', e);
          throw Exception('Schedule generation timed out. Please try again.');
        } else if (errorMessage.contains('400')) {
          _logError('Bad request', e);
          throw Exception(
              'Invalid request to Gemini API. Check your API key and prompt.');
        } else {
          _logError('Unexpected error', e);
          throw Exception('Error generating schedule: ${e.toString()}');
        }
      }
    }

    // This should not be reached due to the retry logic, but added as a fallback
    throw Exception('Failed to generate schedule after multiple attempts.');
  }

// Helper function to format the goals list concisely
  String _formatGoalsList(List<String> goals) {
    final buffer = StringBuffer();
    for (int i = 0; i < goals.length; i++) {
      buffer.writeln('${i + 1}. ${goals[i]}');
    }
    return buffer.toString();
  }

// Helper function to format dates consistently
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

// Helper function to parse the response
  List<Map<String, dynamic>> _parseScheduleResponse(String rawResponse) {
    // Clean the response to extract just the JSON
    rawResponse = rawResponse.trim();

    // Try to find a JSON object in the response
    final jsonMatch = RegExp(r'({[\s\S]*})').firstMatch(rawResponse);

    if (jsonMatch == null) {
      throw const FormatException('Could not find valid JSON in response');
    }

    final jsonString = jsonMatch.group(1)!;

    try {
      final jsonResponse = jsonDecode(jsonString);
      return _transformResponseToSessions(jsonResponse);
    } catch (e) {
      // If standard JSON parsing fails, try a more aggressive extraction
      _logError('JSON parsing error', e);

      // Look for anything that might be the weeks array
      final weeksMatch =
          RegExp(r'"weeks"\s*:\s*(\[[\s\S]*?\])').firstMatch(rawResponse);

      if (weeksMatch == null) {
        throw const FormatException('Could not find weeks data in response');
      }

      try {
        final weeksJson = jsonDecode('{"weeks": ${weeksMatch.group(1)}}');
        return _transformResponseToSessions(weeksJson);
      } catch (e) {
        throw FormatException('Failed to parse schedule data: ${e.toString()}');
      }
    }
  }

// Transform the JSON response to the required session format
  List<Map<String, dynamic>> _transformResponseToSessions(
      Map<String, dynamic> jsonResponse) {
    final List<Map<String, dynamic>> sessionsList = [];

    if (!jsonResponse.containsKey('weeks')) {
      throw const FormatException('Missing "weeks" key in response');
    }

    final weeks = jsonResponse['weeks'] as List<dynamic>;

    if (weeks.isEmpty) {
      throw const FormatException('Empty weeks array in response');
    }

    for (final week in weeks) {
      if (week is Map<String, dynamic>) {
        // Validate required fields
        if (!week.containsKey('session') ||
            !week.containsKey('date') ||
            !week.containsKey('goals')) {
          continue; // Skip invalid entries
        }

        // Parse date to validate format
        try {
          DateTime.parse(week['date']);
        } catch (e) {
          continue; // Skip entries with invalid dates
        }

        // Add the session with additional fields
        sessionsList.add({
          "session": week['session'],
          "date": week['date'],
          "goals": List<String>.from(week['goals']),
          'rate': 0,
          "notes": "",
          "tasks": [],
          "completed": false,
        });
      }
    }

    if (sessionsList.isEmpty) {
      throw Exception('No valid sessions could be parsed from the response');
    }

    return sessionsList;
  }
}

// Log errors for debugging
void _logError(String type, dynamic error) {
}
