import 'package:flutter/material.dart';
import '../controllers/admin_controller.dart';
import 'cms_management_view.dart';
import 'ai_management_view.dart';

class AdminDashboardView extends StatefulWidget {
  final AdminController controller;
  final String adminUser;

  const AdminDashboardView({
    Key? key,
    required this.controller,
    required this.adminUser,
  }) : super(key: key);

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.loadAdminDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apps Alternator Admin Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => widget.controller.loadAdminDashboard(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          if (widget.controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = widget.controller.stats;
          if (stats == null) {
            return const Center(child: Text('Unable to load server analytics'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick navigation row
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.category),
                        label: const Text('CMS Settings'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CmsManagementView(
                                controller: widget.controller,
                                adminUser: widget.adminUser,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.psychology),
                        label: const Text('AI Settings'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AiManagementView(
                                controller: widget.controller,
                                adminUser: widget.adminUser,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Overall Platform Metrics section
                const Text(
                  'Platform Analytics Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Platform User metrics
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _buildStatsCard(
                      'Total Registrations',
                      '${stats.totalUsers}',
                      Icons.people_outline,
                      Colors.blue.shade100,
                      Colors.blue.shade800,
                    ),
                    _buildStatsCard(
                      'Active Users',
                      '${stats.activeUsers}',
                      Icons.trending_up,
                      Colors.teal.shade100,
                      Colors.teal.shade800,
                    ),
                    _buildStatsCard(
                      'Premium Members',
                      '${stats.premiumUsers}',
                      Icons.star,
                      Colors.amber.shade100,
                      Colors.amber.shade900,
                    ),
                    _buildStatsCard(
                      'Free Trial Accounts',
                      '${stats.trialUsers}',
                      Icons.hourglass_empty,
                      Colors.purple.shade100,
                      Colors.purple.shade800,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Financial Overview Widget
                const Text(
                  'Financial Analytics & Conversion Rates',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildMetricRow('Total Platform Revenue', '₹${stats.revenue.totalRevenue.toStringAsFixed(2)}', Colors.teal),
                        const Divider(),
                        _buildMetricRow('Premium Membership Revenue', '₹${stats.revenue.premiumSubscriptionRevenue.toStringAsFixed(2)}', Colors.blue),
                        const Divider(),
                        _buildMetricRow('Estimated AdMob Revenue', '₹${stats.revenue.adRevenue.toStringAsFixed(2)}', Colors.amber.shade800),
                        const Divider(),
                        _buildMetricRow('Trial-to-Premium Conversion', '${(stats.revenue.trialConversionRate * 100).toStringAsFixed(0)}%', Colors.purple),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Search Trends Overview
                const Text(
                  'Most Queried Core Applications',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stats.searchTrends.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final key = stats.searchTrends.keys.elementAt(index);
                      final val = stats.searchTrends[key];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 12,
                          child: Text('${index + 1}', style: const TextStyle(fontSize: 10)),
                        ),
                        title: Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text('$val searches', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Crash logs & errors
                const Text(
                  'Server Health & Diagnostics Logs',
                  style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Card(
                  color: Colors.red.shade50,
                  borderOnForeground: true,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: stats.errorLogs.map((log) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          log,
                          style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: Colors.red.shade900),
                        ),
                      )).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard(String title, String val, IconData icon, Color bg, Color color) {
    return Card(
      color: bg,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                Text(title, style: TextStyle(fontSize: 11, color: color.withOpacity(0.8))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: valueColor, fontSize: 14)),
        ],
      ),
    );
  }
}
