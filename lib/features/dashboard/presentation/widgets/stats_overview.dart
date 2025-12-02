import 'package:flutter/material.dart';

class StatsOverview extends StatelessWidget {
  final int totalServers;
  final int onlineServers;
  final double avgCpuUsage;
  final double avgMemoryUsage;

  const StatsOverview({
    super.key,
    required this.totalServers,
    required this.onlineServers,
    required this.avgCpuUsage,
    required this.avgMemoryUsage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewItem(
                    context,
                    'Total Servers',
                    '$totalServers',
                    Icons.dns,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildOverviewItem(
                    context,
                    'Online',
                    '$onlineServers',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewItem(
                    context,
                    'Avg CPU',
                    '${avgCpuUsage.toStringAsFixed(1)}%',
                    Icons.memory,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildOverviewItem(
                    context,
                    'Avg Memory',
                    '${avgMemoryUsage.toStringAsFixed(1)}%',
                    Icons.storage,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
