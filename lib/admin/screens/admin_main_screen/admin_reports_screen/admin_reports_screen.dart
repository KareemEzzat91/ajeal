import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/models/doctor_model/doctor_model.dart';
import '../../../../features/admin/children/data/doctor_repository.dart';
import '../../../../features/admin/children/presentation/cubit/doctor_meta/doctor_meta_cubit.dart';
import '../../../../features/admin/children/presentation/cubit/doctor_meta/doctor_meta_state.dart';
import '../../../../helpers/generated/l10n.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  String selectedPeriod = 'This Month';
  String selectedReport = 'Overview';

  final Color primaryColor = const Color(0xff0186c7);
  final Color secondaryColor = const Color(0xff1e3a5c);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorMetaCubit(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            S.of(context).reportsAnalytics,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.file_download_outlined),
              onPressed: () {},
              tooltip: S.of(context).exportReports,
            ),
          ],
        ),
        body: FutureBuilder<Doctor?>(
            future: sl<DoctorRepository>()
                .getDoctorInfo(FirebaseAuth.instance.currentUser?.uid ?? ''),
            builder: (context, snap) {
              final Doctor? data;
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                data = Doctor(
                    lastChattedWith: " ",
                    lastChildId: 0,
                    lastChildName: "",
                    lastSessionWith: "",
                    taskAddedFor: "");
              } else {
                data = snap.data;
              }
              return Column(
                children: [
                  _buildReportHeader(data?.lastChildId.toString() ?? "0"),
                  Expanded(
                    child: _buildReportContent(data),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget _buildReportHeader(String totalChildren) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  value: S.of(context).thisMonth,
                  items: [
                    S.of(context).today,
                    S.of(context).thisWeek,
                    S.of(context).thisMonth,
                    S.of(context).thisYear,
                    S.of(context).custom,
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedPeriod = value!;
                    });
                  },
                  icon: Icons.calendar_today,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  value: selectedReport,
                  items: [
                    'Overview',
                    'Children',
                    'Goals',
                    'Sessions',
                    'Progress'
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedReport = value!;
                    });
                  },
                  icon: Icons.analytics,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildQuickStats(totalChildren),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xff1e3a5c)),
        underline: const SizedBox(),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Icon(icon, size: 16, color: primaryColor),
                const SizedBox(width: 12),
                Text(
                  value,
                  style: TextStyle(color: secondaryColor, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildQuickStats(String totalChildren) {
    return Row(
      children: [
        BlocBuilder<DoctorMetaCubit, DoctorMetaState>(
          builder: (context, state) {
            return _buildStatCard(
              title: S.of(context).totalChildren,
              value: totalChildren,
              icon: Icons.child_care,
              color: Colors.white,
              trend: '+12%',
              isPositive: true,
            );
          },
        ),
        _buildStatCard(
          title: S.of(context).activeGoals,
          value: '7',
          icon: Icons.track_changes,
          color: Colors.white,
          trend: '+8%',
          isPositive: true,
        ),
        _buildStatCard(
          title: S.of(context).successRate,
          value: '78%',
          icon: Icons.trending_up,
          color: Colors.white,
          trend: '-2%',
          isPositive: false,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
    required bool isPositive,
  }) {
    return Expanded(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: primaryColor, size: 20),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPositive ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      trend,
                      style: TextStyle(
                        color: isPositive ? Colors.green[700] : Colors.red[700],
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportContent(Doctor? data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(S.of(context).detailedReports),
          const SizedBox(height: 20),
          _buildReportGrid(),
          const SizedBox(height: 30),
          _buildSectionTitle(S.of(context).recentActivities),
          const SizedBox(height: 16),
          _buildActivityList(data),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: secondaryColor,
      ),
    );
  }

  Widget _buildReportGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildReportCard(
          title: S.of(context).ageDistribution,
          description: 'Distribution of children by age groups',
          icon: Icons.pie_chart,
          color: const Color(0xff9c27b0),
        ),
        _buildReportCard(
          title: S.of(context).goalProgress,
          description: 'Overall progress tracking for goals',
          icon: Icons.bar_chart,
          color: primaryColor,
        ),
        _buildReportCard(
          title: S.of(context).sessionAnalysis,
          description: 'Analysis of therapy sessions',
          icon: Icons.timeline,
          color: const Color(0xffff9800),
        ),
        _buildReportCard(
          title: S.of(context).successMetrics,
          description: 'Key performance indicators',
          icon: Icons.assessment,
          color: const Color(0xff4caf50),
        ),
      ],
    );
  }

  Widget _buildReportCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityList(Doctor? data) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          final List<String> names = [
            data?.lastChildName ?? "",
            data?.taskAddedFor ?? "",
            data?.lastSessionWith ?? "",
            data?.lastChildId.toString() ?? "",
            data?.lastChattedWith ?? "",
          ];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.primaries[index % Colors.primaries.length],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getActivityIcon(index),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              title: Text(
                _getActivityTitle(index),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: secondaryColor,
                  fontSize: 15,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  names[index],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.chevron_right, color: primaryColor),
                onPressed: () {
                  // Add navigation or action here
                },
              ),
            ),
          );
        });
  }

  IconData _getActivityIcon(int index) {
    final icons = [
      Icons.person_add,
      Icons.edit,
      Icons.check_circle,
      Icons.assessment,
      Icons.calendar_today,
    ];
    return icons[index];
  }

  String _getActivityTitle(int index) {
    final activities = [
      S.of(context).newChildRegistered,
      S.of(context).goalUpdated,
      S.of(context).sessionCompleted,
      S.of(context).monthlyReportGenerated,
      S.of(context).appointmentScheduled,
    ];
    return activities[index];
  }
}
