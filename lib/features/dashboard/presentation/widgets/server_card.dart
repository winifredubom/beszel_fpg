import 'package:flutter/material.dart';

class ServerCard extends StatelessWidget {
  final String id;
  final String name;
  final String host;
  final bool isOnline;
  final double? cpuUsage;
  final double? memoryUsage;
  final double? diskUsage;
  final VoidCallback? onTap;

  const ServerCard({
    super.key,
    required this.id,
    required this.name,
    required this.host,
    required this.isOnline,
    this.cpuUsage,
    this.memoryUsage,
    this.diskUsage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          host,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isOnline ? 'Online' : 'Offline',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (isOnline && cpuUsage != null && memoryUsage != null && diskUsage != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        context,
                        'CPU',
                        '${cpuUsage!.toStringAsFixed(1)}%',
                        Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        'Memory',
                        '${memoryUsage!.toStringAsFixed(1)}%',
                        Colors.green,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        'Disk',
                        '${diskUsage!.toStringAsFixed(1)}%',
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
