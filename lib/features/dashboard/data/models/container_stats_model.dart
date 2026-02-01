/// Container stats response (root)
class ContainerStatsResponse {
  final List<ContainerStatRecord> items;
  final int page;
  final int perPage;
  final int totalItems;
  final int totalPages;

  const ContainerStatsResponse({
    required this.items,
    required this.page,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
  });

  factory ContainerStatsResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? const []);
    return ContainerStatsResponse(
      items: rawItems
          .map((e) => ContainerStatRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num?)?.toInt() ?? 0,
      perPage: (json['perPage'] as num?)?.toInt() ?? 0,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
        'page': page,
        'perPage': perPage,
        'totalItems': totalItems,
        'totalPages': totalPages,
      };
}

/// Each record in `items` - contains a timestamp and list of container stats
class ContainerStatRecord {
  final DateTime created;
  final List<ContainerStats> stats;

  const ContainerStatRecord({
    required this.created,
    required this.stats,
  });

  factory ContainerStatRecord.fromJson(Map<String, dynamic> json) {
    final rawStats = (json['stats'] as List<dynamic>? ?? const []);
    return ContainerStatRecord(
      created: _parseCreated(json['created'] as String?),
      stats: rawStats
          .map((e) => ContainerStats.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'created': created.toUtc().toIso8601String(),
        'stats': stats.map((e) => e.toJson()).toList(),
      };

  static DateTime _parseCreated(String? value) {
    if (value == null || value.trim().isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    }

    // Convert "2026-01-16 23:46:54.676Z" -> "2026-01-16T23:46:54.676Z"
    final normalized = value.contains(' ')
        ? value.replaceFirst(' ', 'T')
        : value;

    return DateTime.tryParse(normalized)?.toUtc() ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
}

/// Individual container stats
/// - c: CPU usage percentage
/// - m: Memory usage in MB
/// - n: Container name
/// - nr: Network received bytes/sec
/// - ns: Network sent bytes/sec
class ContainerStats {
  final double c;      // CPU usage %
  final double m;      // Memory usage MB
  final String n;      // Container name
  final double nr;     // Network received
  final double ns;     // Network sent

  const ContainerStats({
    required this.c,
    required this.m,
    required this.n,
    required this.nr,
    required this.ns,
  });

  // Convenience getters with readable names
  double get cpuUsage => c;
  double get memoryMB => m;
  String get containerName => n;
  double get networkReceived => nr;
  double get networkSent => ns;

  factory ContainerStats.fromJson(Map<String, dynamic> json) {
    return ContainerStats(
      c: (json['c'] as num?)?.toDouble() ?? 0.0,
      m: (json['m'] as num?)?.toDouble() ?? 0.0,
      n: json['n'] as String? ?? '',
      nr: (json['nr'] as num?)?.toDouble() ?? 0.0,
      ns: (json['ns'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'c': c,
        'm': m,
        'n': n,
        'nr': nr,
        'ns': ns,
      };
}

/// Aggregated container data for charts
/// Groups all stats by container name for time-series display
class AggregatedContainerData {
  final String containerName;
  final List<double> cpuData;
  final List<double> memoryData;
  final List<DateTime> timestamps;

  const AggregatedContainerData({
    required this.containerName,
    required this.cpuData,
    required this.memoryData,
    required this.timestamps,
  });

  double get currentCpu => cpuData.isNotEmpty ? cpuData.last : 0.0;
  double get maxCpu => cpuData.isNotEmpty ? cpuData.reduce((a, b) => a > b ? a : b) : 0.0;
  double get currentMemory => memoryData.isNotEmpty ? memoryData.last : 0.0;
  double get maxMemory => memoryData.isNotEmpty ? memoryData.reduce((a, b) => a > b ? a : b) : 0.0;
}

/// Helper to aggregate container stats from response
List<AggregatedContainerData> aggregateContainerStats(ContainerStatsResponse response) {
  final Map<String, List<({DateTime time, double cpu, double mem})>> dataByContainer = {};

  for (final record in response.items) {
    for (final stat in record.stats) {
      dataByContainer.putIfAbsent(stat.n, () => []);
      dataByContainer[stat.n]!.add((
        time: record.created,
        cpu: stat.c,
        mem: stat.m,
      ));
    }
  }

  return dataByContainer.entries.map((entry) {
    final sortedData = entry.value..sort((a, b) => a.time.compareTo(b.time));
    return AggregatedContainerData(
      containerName: entry.key,
      cpuData: sortedData.map((e) => e.cpu).toList(),
      memoryData: sortedData.map((e) => e.mem).toList(),
      timestamps: sortedData.map((e) => e.time).toList(),
    );
  }).toList();
}
