/// System stats response (root)
class SystemStatsResponse {
  final List<SystemStatRecord> items;
  final int page;
  final int perPage;
  final int totalItems;
  final int totalPages;

  const SystemStatsResponse({
    required this.items,
    required this.page,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
  });

  factory SystemStatsResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? const []);
    return SystemStatsResponse(
      items: rawItems
          .map((e) => SystemStatRecord.fromJson(e as Map<String, dynamic>))
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

/// Each record in `items`
class SystemStatRecord {
  final DateTime created;
  final SystemStats stats;

  const SystemStatRecord({
    required this.created,
    required this.stats,
  });

  factory SystemStatRecord.fromJson(Map<String, dynamic> json) {
    return SystemStatRecord(
      created: _parseCreated(json['created'] as String?),
      stats: SystemStats.fromJson(
        (json['stats'] as Map<String, dynamic>? ?? const {}),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'created': created.toUtc().toIso8601String(),
        'stats': stats.toJson(),
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

/// Nested `stats` object
class SystemStats {
  final double cpu;
  final double d;
  final double dp;
  final double dr;
  final double du;
  final double dw;

  final double m;
  final double mb;
  final double mp;
  final double mu;

  final double nr;
  final double ns;

  const SystemStats({
    required this.cpu,
    required this.d,
    required this.dp,
    required this.dr,
    required this.du,
    required this.dw,
    required this.m,
    required this.mb,
    required this.mp,
    required this.mu,
    required this.nr,
    required this.ns,
  });

  factory SystemStats.fromJson(Map<String, dynamic> json) {
    double dVal(String key) => (json[key] as num?)?.toDouble() ?? 0.0;

    return SystemStats(
      cpu: dVal('cpu'),
      d: dVal('d'),
      dp: dVal('dp'),
      dr: dVal('dr'),
      du: dVal('du'),
      dw: dVal('dw'),
      m: dVal('m'),
      mb: dVal('mb'),
      mp: dVal('mp'),
      mu: dVal('mu'),
      nr: dVal('nr'),
      ns: dVal('ns'),
    );
  }

  Map<String, dynamic> toJson() => {
        'cpu': cpu,
        'd': d,
        'dp': dp,
        'dr': dr,
        'du': du,
        'dw': dw,
        'm': m,
        'mb': mb,
        'mp': mp,
        'mu': mu,
        'nr': nr,
        'ns': ns,
      };
}
