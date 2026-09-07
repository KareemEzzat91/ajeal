import 'package:ajeal/core/routing/routes.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:go_router/go_router.dart';

import 'package:ajeal/core/models/child_model/child_model.dart';
import 'package:ajeal/helpers/generated/l10n.dart';

class ProgressSection extends StatelessWidget {
  final Color theme;
  final Child child;
  final bool isOthers;
  final bool isAnalysisEmpty;

  const ProgressSection({
    super.key,
    required this.theme,
    required this.child,
    required this.isOthers,
    required this.isAnalysisEmpty,
  });

  @override
  Widget build(BuildContext context) {
    final int totalSessions = child.scheduleSessions.length;
    final int completedSessions = child.scheduleSessions
        .where((session) => session['completed'] == true)
        .length;

    final double progressValue =
        totalSessions > 0 ? completedSessions / totalSessions : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).progress,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '$completedSessions من $totalSessions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey[200],
                  color: Colors.blue,
                  minHeight: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progressValue * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              if (progressValue >= 1.0)
                const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "مكتمل",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (progressValue >= 1.0) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                isAnalysisEmpty
                    ? showAIResults(context, child)
                    : context
                        .push(Routes.adminChildrenDetailsAiResults, extra: {
                        'childName': child.name,
                        'analysis': child.analysis,
                        'sessionsData': child.scheduleSessions
                            .where((s) => s['isCompleted'] == true)
                            .toList()
                      });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.analytics),
              label: const Text(
                "اظهار نتائج التحليل",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void showAIResults(BuildContext context, Child child) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Prepare session data for AI analysis
      final List<Map<String, dynamic>> sessionsData = child.scheduleSessions
          .where((session) => session['completed'] == true)
          .map((session) => {
                "session": session["session"],
                "date": session["date"],
                "goals": session["goals"],
                "rate": session["rate"],
                "notes": session["notes"],
                "tasks": session["tasks"],
              })
          .toList();

      // Format data for Gemini API
      final String prompt = """
    قم بتحليل بيانات الجلسات العلاجية التالية واستخرج النتائج النهائية للفترة بالكامل، مع تقديم توصيات للآباء حول كيفية تحسين دعم الطفل في المستقبل. يشمل التحليل:
    1. الأنماط العامة للتقدم خلال الفترة
    2. تحقيق الأهداف وتقييم مستوى الإنجاز
    3. نقاط القوة التي يجب تعزيزها
    4. المجالات التي تحتاج إلى تحسين والتركيز عليها
    5. توصيات مخصصة للآباء لمساعدة الطفل في المرحلة القادمة

    بيانات الجلسات:
    ${jsonEncode(sessionsData)}
    """;

      // Call Gemini API (implementation depends on your Gemini integration)
      final String aiAnalysis = await callGeminiAPI(prompt);
      final batch = FirebaseFirestore.instance.batch();

      DocumentReference childDoc = FirebaseFirestore.instance
          .collection("Children")
          .doc(child.parentPhone);
      batch.update(childDoc, {"analysis": aiAnalysis});

      if (!isOthers) {
        DocumentReference userChildDoc = FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("children")
            .doc(child.parentPhone);

        batch.update(userChildDoc, {"analysis": aiAnalysis});
      }

// تنفيذ كل العمليات دفعة واحدة
      await batch.commit();

      // Close loading dialog
      if (!context.mounted) return;
      context.pop();

      // Navigate to results screen
      context.push(Routes.adminChildrenDetailsAiResults, extra: {
        'childName': child.name,
        'analysis': aiAnalysis,
        'sessionsData': sessionsData
      });
    } catch (e) {
      // Close loading dialog
      if (!context.mounted) return;
      context.pop();

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("حدث خطأ: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String> callGeminiAPI(String prompt) async {
    final gemini = Gemini.instance;
    int retryCount = 0;
    const maxRetries = 3;
    const baseDelay = 2000; // 2 seconds

    while (retryCount < maxRetries) {
      try {
        // Make API request with timeout
        final response =
            await gemini.prompt(parts: [Part.text(prompt)]).timeout(
          const Duration(seconds: 130),
          onTimeout: () =>
              throw TimeoutException('Gemini API request timed out'),
        );

        if (response == null ||
            response.output == null ||
            response.output!.isEmpty) {
          throw Exception('Empty response from Gemini API');
        }

        // Return the raw output text
        return response.output!;
      } on Exception catch (e) {
        final errorMessage = e.toString().toLowerCase();

        // Check specifically for rate limit errors (429)
        if (errorMessage.contains('429') ||
            errorMessage.contains('too many requests')) {
          retryCount++;
          if (retryCount >= maxRetries) {
            _logError(
                'Rate limit exceeded', 'Max retries reached after 429 error');
            throw Exception(
                'معدل الطلبات تجاوز الحد المسموح. الرجاء المحاولة لاحقاً.');
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
          throw Exception('انتهت مدة الاتصال. الرجاء المحاولة مرة أخرى.');
        } else if (errorMessage.contains('400')) {
          _logError('Bad request', e);
          throw Exception(
              'طلب غير صالح إلى واجهة Gemini. تحقق من مفتاح API والمحتوى المرسل.');
        } else {
          _logError('Unexpected error', e);
          throw Exception('حدث خطأ أثناء تحليل البيانات: ${e.toString()}');
        }
      }
    }

    // This should not be reached due to the retry logic, but added as a fallback
    throw Exception('فشل في تحليل البيانات بعد عدة محاولات.');
  }

  void _logError(String type, dynamic error) {}
}
