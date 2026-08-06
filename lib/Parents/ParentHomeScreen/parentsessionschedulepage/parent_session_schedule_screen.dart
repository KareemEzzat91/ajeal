import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/SessionDetailScreen/SessionDetailScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildDetailsScreen/child_proggress.dart';
import 'package:ajeal/Admin/models/ChildModel/ChildModel.dart';
import 'package:flutter/material.dart';

class SessionSchedulePage extends StatelessWidget {
  final String childId;
  final Child child;
  final List<Map<String, dynamic>> scheduleSessions;
  final bool isParent;
  final String name ;
  final int completedSesions;

  const SessionSchedulePage({
    super.key,
    required this.childId,
    required this.child,
    required this.scheduleSessions,
    required this.isParent,
    required this.name ,
    required this.completedSesions ,


  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: _buildUpcomingSession(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _buildSessionsList(),

          ),
          SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 16), sliver: SliverToBoxAdapter(child: ProgressSection(child: child,theme:theme.primaryColor,isOthers: false,isAnalysisEmpty: child.analysis.isEmpty,))),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          "Session Schedule",
          style: TextStyle(color: Colors.white),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue, Colors.blue.shade700],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Icon(
                  Icons.calendar_today,
                  size: 150,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingSession() {
    if (scheduleSessions.isEmpty) {
      return _buildEmptyState();
    }
    final nextSession = scheduleSessions[ completedSesions==scheduleSessions.length?completedSesions-1:completedSesions+1];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Next Session",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.notifications, color: Colors.white),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Session ${nextSession['session']}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nextSession['date'],
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List<String>.from(nextSession['goals']).map((goal) {
              return Chip(
                label: Text(
                  goal,
                  style: TextStyle(color: Colors.blue.shade700),
                ),
                backgroundColor: Colors.white,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.calendar_today,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            "No Sessions Scheduled",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Schedule your first session by clicking the button below",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final session = scheduleSessions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSessionCard(context, session),
          );
        },
        childCount: scheduleSessions.length,
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, Map<String, dynamic> session) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SessionDetailScreen(
                childName: name,
                isParent: true,
                childId: childId,
                sessionName: session['session'],
                date: session['date'],
                goals: List<String>.from(session['goals']),
                notes: session['notes'] ?? 0,
                rate: session['rate'] ?? 0.0,
                tasks: List.from(session['tasks'] ?? []),
                isCompleted: session['completed'] ?? 0,

              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Session ${session['session']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildSessionStatus(session["completed"]),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    session['date'],
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Goals:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List<String>.from(session['goals']).map((goal) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      goal,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (session['notes'] != null && session['notes'].isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  "Notes:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  session['notes'],
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SessionDetailScreen(
                            childName: name ,
                            isParent: true,
                            childId: childId,
                            sessionName: session['session'],
                            date: session['date'],
                            goals: List<String>.from(session['goals']),
                            notes: session['notes'] ?? '',
                            rate: session['rate'] ?? 0.0,
                            tasks: List.from(session['tasks'] ?? []),
                            isCompleted: session['completed'] ?? 0,

                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text("View Details"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionStatus(bool isCompleted ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
       isCompleted?"Completed ": "Scheduled",
        style: TextStyle(
          color: Colors.green.shade700,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


}
