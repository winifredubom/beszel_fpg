class SystemRecordsResponse {
  final List<SystemRecordItem> items;
  final int page;
  final int perPage;
  final int totalItems;
  final int totalPages;

  SystemRecordsResponse({
    required this.items,
    required this.page,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
  });

  factory SystemRecordsResponse.fromJson(Map<String, dynamic> json) {
    return SystemRecordsResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => SystemRecordItem.fromJson(e))
          .toList(),
      page: json['page'] as int,
      perPage: json['perPage'] as int,
      totalItems: json['totalItems'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'page': page,
      'perPage': perPage,
      'totalItems': totalItems,
      'totalPages': totalPages,
    };
  }
}

class SystemRecordItem {
  final String host;
  final String id;
  final SystemInfo info;
  final String name;
  final String port;
  final String status;

  SystemRecordItem({
    required this.host,
    required this.id,
    required this.info,
    required this.name,
    required this.port,
    required this.status,
  });

  factory SystemRecordItem.fromJson(Map<String, dynamic> json) {
    return SystemRecordItem(
      host: json['host'] as String,
      id: json['id'] as String,
      info: SystemInfo.fromJson(json['info']),
      name: json['name'] as String,
      port: json['port'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'host': host,
      'id': id,
      'info': info.toJson(),
      'name': name,
      'port': port,
      'status': status,
    };
  }
}

class SystemInfo {
  final double b;
  final int c;
  final double cpu;
  final double dp;
  final String h;
  final String k;
  final String m;
  final double mp;
  final int os;
  final int t;
  final int u;
  final String v;

  SystemInfo({
    required this.b,
    required this.c,
    required this.cpu,
    required this.dp,
    required this.h,
    required this.k,
    required this.m,
    required this.mp,
    required this.os,
    required this.t,
    required this.u,
    required this.v,
  });

  factory SystemInfo.fromJson(Map<String, dynamic> json) {
    return SystemInfo(
      b: (json['b'] as num).toDouble(),
      c: json['c'] as int,
      cpu: (json['cpu'] as num).toDouble(),
      dp: (json['dp'] as num).toDouble(),
      h: json['h'] as String,
      k: json['k'] as String,
      m: json['m'] as String,
      mp: (json['mp'] as num).toDouble(),
      os: json['os'] as int,
      t: json['t'] as int,
      u: json['u'] as int,
      v: json['v'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'b': b,
      'c': c,
      'cpu': cpu,
      'dp': dp,
      'h': h,
      'k': k,
      'm': m,
      'mp': mp,
      'os': os,
      't': t,
      'u': u,
      'v': v,
    };
  }
}
