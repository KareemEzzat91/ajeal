import 'package:flutter/material.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  String selectedPeriod = 'This Month';
  String selectedReport = 'Overview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        elevation: 0,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  value: selectedPeriod,
                  items: ['Today', 'This Week', 'This Month', 'This Year', 'Custom'],
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
                  items: ['Overview', 'Children', 'Goals', 'Sessions', 'Progress'],
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
          const SizedBox(height: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        underline: const SizedBox(),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(value),
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
          color: Colors.blue,
        ),
        _buildStatCard(
          title: 'Active Goals',
          value: '342',
          icon: Icons.track_changes,
          color: Colors.green,
        ),
        _buildStatCard(
          title: 'Success Rate',
          value: '78%',
          icon: Icons.trending_up,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize:9,
                    ),
                  ),
                ],
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Detailed Reports'),
          const SizedBox(height: 16),
          _buildReportGrid(),
          const SizedBox(height: 24),
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
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
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
      childAspectRatio: 1.3,
      children: [
        _buildReportCard(
          title: 'Age Distribution',
          description: 'Distribution of children by age groups',
          icon: Icons.pie_chart,
          color: Colors.purple,
        ),
        _buildReportCard(
          title: 'Goal Progress',
          description: 'Overall progress tracking for goals',
          icon: Icons.bar_chart,
          color: Colors.blue,
        ),
        _buildReportCard(
          title: 'Session Analysis',
          description: 'Analysis of therapy sessions',
          icon: Icons.timeline,
          color: Colors.orange,
        ),
        _buildReportCard(
          title: 'Success Metrics',
          description: 'Key performance indicators',
          icon: Icons.assessment,
          color: Colors.green,
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
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Navigate to detailed report
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
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
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.primaries[index % Colors.primaries.length],
              child: Icon(
                _getActivityIcon(index),
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(_getActivityTitle(index)),
            subtitle: Text(_getActivityTime(index)),
            trailing: IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                // Navigate to activity details
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