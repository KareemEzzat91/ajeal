import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Reports & Analytics',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () {},
            tooltip: 'Export Reports',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildReportHeader(),
          Expanded(
            child: _buildReportContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildReportHeader() {
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
                  value: selectedPeriod,
                  items: [
                    'Today',
                    'This Week',
                    'This Month',
                    'This Year',
                    'Custom'
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
          _buildQuickStats(),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                Icon(icon, size: 18, color: primaryColor),
                const SizedBox(width: 12),
                Text(
                  value,
                  style: TextStyle(color: secondaryColor, fontSize: 14),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _buildStatCard(
          title: 'Total Children',
          value: '156',
          icon: Icons.child_care,
          color: Colors.white,
          trend: '+12%',
          isPositive: true,
        ),
        _buildStatCard(
          title: 'Active Goals',
          value: '342',
          icon: Icons.track_changes,
          color: Colors.white,
          trend: '+8%',
          isPositive: true,
        ),
        _buildStatCard(
          title: 'Success Rate',
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
                  Icon(icon, color: primaryColor, size: 24),
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
                        fontSize: 12,
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
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Detailed Reports'),
          const SizedBox(height: 20),
          _buildReportGrid(),
          const SizedBox(height: 30),
          _buildSectionTitle('Recent Activities'),
          const SizedBox(height: 16),
          _buildActivityList(),
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
          title: 'Age Distribution',
          description: 'Distribution of children by age groups',
          icon: Icons.pie_chart,
          color: const Color(0xff9c27b0),
        ),
        _buildReportCard(
          title: 'Goal Progress',
          description: 'Overall progress tracking for goals',
          icon: Icons.bar_chart,
          color: primaryColor,
        ),
        _buildReportCard(
          title: 'Session Analysis',
          description: 'Analysis of therapy sessions',
          icon: Icons.timeline,
          color: const Color(0xffff9800),
        ),
        _buildReportCard(
          title: 'Success Metrics',
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
            border: Border.all(color: color.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
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

  Widget _buildActivityList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
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
                color: Colors.primaries[index % Colors.primaries.length]
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getActivityIcon(index),
                color: Colors.primaries[index % Colors.primaries.length],
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
                _getActivityTime(index),
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
      },
    );
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
      'New child registered',
      'Goal updated for Ahmed',
      'Session completed with Sara',
      'Monthly report generated',
      'Appointment scheduled',
    ];
    return activities[index];
  }

  String _getActivityTime(int index) {
    final times = [
      '2 hours ago',
      '4 hours ago',
      'Yesterday',
      'Yesterday',
      '2 days ago',
    ];
    return times[index];
  }
}
