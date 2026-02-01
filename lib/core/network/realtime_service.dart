import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/storage_service.dart';

/// Realtime event from SSE stream
class RealtimeEvent {
  final String id;
  final String event;
  final Map<String, dynamic> data;

  RealtimeEvent({
    required this.id,
    required this.event,
    required this.data,
  });

  @override
  String toString() => 'RealtimeEvent(id: $id, event: $event, data: $data)';
}

/// System record from realtime update
class RealtimeSystemRecord {
  final String id;
  final String collectionId;
  final String collectionName;
  final String name;
  final String host;
  final String port;
  final String status;
  final String created;
  final String updated;
  final RealtimeSystemInfo info;
  final List<String> users;

  RealtimeSystemRecord({
    required this.id,
    required this.collectionId,
    required this.collectionName,
    required this.name,
    required this.host,
    required this.port,
    required this.status,
    required this.created,
    required this.updated,
    required this.info,
    required this.users,
  });

  factory RealtimeSystemRecord.fromJson(Map<String, dynamic> json) {
    return RealtimeSystemRecord(
      id: json['id'] ?? '',
      collectionId: json['collectionId'] ?? '',
      collectionName: json['collectionName'] ?? '',
      name: json['name'] ?? '',
      host: json['host'] ?? '',
      port: json['port'] ?? '',
      status: json['status'] ?? 'unknown',
      created: json['created'] ?? '',
      updated: json['updated'] ?? '',
      info: RealtimeSystemInfo.fromJson(json['info'] ?? {}),
      users: (json['users'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'collectionId': collectionId,
        'collectionName': collectionName,
        'name': name,
        'host': host,
        'port': port,
        'status': status,
        'created': created,
        'updated': updated,
        'info': info.toJson(),
        'users': users,
      };
}

class RealtimeSystemInfo {
  final String h; // hostname
  final String k; // kernel
  final int c; // cpu cores
  final int t; // total cores
  final String m; // machine type
  final int u; // uptime
  final double cpu; // cpu usage
  final double mp; // memory percentage
  final double dp; // disk percentage
  final double b; // bandwidth
  final String v; // version
  final int os; // os type

  RealtimeSystemInfo({
    required this.h,
    required this.k,
    required this.c,
    required this.t,
    required this.m,
    required this.u,
    required this.cpu,
    required this.mp,
    required this.dp,
    required this.b,
    required this.v,
    required this.os,
  });

  factory RealtimeSystemInfo.fromJson(Map<String, dynamic> json) {
    return RealtimeSystemInfo(
      h: json['h']?.toString() ?? '',
      k: json['k']?.toString() ?? '',
      c: (json['c'] as num?)?.toInt() ?? 0,
      t: (json['t'] as num?)?.toInt() ?? 0,
      m: json['m']?.toString() ?? '',
      u: (json['u'] as num?)?.toInt() ?? 0,
      cpu: (json['cpu'] as num?)?.toDouble() ?? 0.0,
      mp: (json['mp'] as num?)?.toDouble() ?? 0.0,
      dp: (json['dp'] as num?)?.toDouble() ?? 0.0,
      b: (json['b'] as num?)?.toDouble() ?? 0.0,
      v: json['v']?.toString() ?? '',
      os: (json['os'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'h': h,
        'k': k,
        'c': c,
        't': t,
        'm': m,
        'u': u,
        'cpu': cpu,
        'mp': mp,
        'dp': dp,
        'b': b,
        'v': v,
        'os': os,
      };
}

/// Realtime service for SSE connections using Dio
class RealtimeService {
  static const String _baseUrl = 'https://beszel.flexipgroup.com/api';
  
  final Dio _dio;
  CancelToken? _cancelToken;
  StreamSubscription? _subscription;
  String? _clientId;
  bool _isConnected = false;
  
  final _systemsController = StreamController<Map<String, RealtimeSystemRecord>>.broadcast();
  final _alertsController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();
  
  // Store systems by ID for quick updates
  final Map<String, RealtimeSystemRecord> _systems = {};
  
  Stream<Map<String, RealtimeSystemRecord>> get systemsStream => _systemsController.stream;
  Stream<Map<String, dynamic>> get alertsStream => _alertsController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  
  bool get isConnected => _isConnected;
  String? get clientId => _clientId;
  Map<String, RealtimeSystemRecord> get currentSystems => Map.unmodifiable(_systems);

  RealtimeService(this._dio);

  /// Connect to the realtime SSE endpoint
  Future<void> connect() async {
    if (_isConnected) {
      debugPrint('🔌 Already connected to realtime');
      return;
    }

    try {
      _cancelToken = CancelToken();
      final token = StorageService.getString('access_token');
      
      debugPrint('🔌 Connecting to realtime SSE...');
      
      final response = await _dio.get<ResponseBody>(
        '$_baseUrl/realtime',
        options: Options(
          headers: {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
            if (token != null && token.isNotEmpty) 'Authorization': token,
          },
          responseType: ResponseType.stream,
        ),
        cancelToken: _cancelToken,
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to connect: ${response.statusCode}');
      }

      _isConnected = true;
      _connectionController.add(true);
      debugPrint('✅ Connected to realtime SSE');

      // Parse SSE stream
      String buffer = '';
      
      _subscription = response.data?.stream
          .transform(StreamTransformer<Uint8List, String>.fromHandlers(
            handleData: (data, sink) {
              sink.add(utf8.decode(data));
            },
          ))
          .listen(
        (chunk) {
          buffer += chunk;
          
          // Process complete events (separated by double newline)
          while (buffer.contains('\n\n')) {
            final eventEnd = buffer.indexOf('\n\n');
            final eventData = buffer.substring(0, eventEnd);
            buffer = buffer.substring(eventEnd + 2);
            
            _processEvent(eventData);
          }
        },
        onError: (error) {
          debugPrint('❌ SSE Error: $error');
          _handleDisconnect();
        },
        onDone: () {
          debugPrint('🔌 SSE Connection closed');
          _handleDisconnect();
        },
        cancelOnError: false,
      );
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        debugPrint('🔌 SSE Connection cancelled');
      } else {
        debugPrint('❌ Failed to connect to realtime: $e');
      }
      _handleDisconnect();
      rethrow;
    }
  }

  /// Process a single SSE event
  void _processEvent(String eventData) {
    String? event;
    String? data;

    for (final line in eventData.split('\n')) {
      if (line.startsWith('event:')) {
        event = line.substring(6).trim();
      } else if (line.startsWith('data:')) {
        data = line.substring(5).trim();
      }
    }

    if (event == null || data == null) return;

    try {
      final jsonData = json.decode(data) as Map<String, dynamic>;
      
      if (event == 'PB_CONNECT') {
        _clientId = jsonData['clientId'] as String?;
        debugPrint('🔑 Got client ID: $_clientId');
        // Subscribe to systems and alerts
        _subscribe();
      } else if (event.startsWith('systems/')) {
        _handleSystemEvent(jsonData);
      } else if (event.startsWith('alerts/')) {
        _handleAlertEvent(jsonData);
      }
    } catch (e) {
      debugPrint('⚠️ Failed to parse event data: $e');
    }
  }

  /// Handle system update event
  void _handleSystemEvent(Map<String, dynamic> jsonData) {
    final action = jsonData['action'] as String?;
    final recordData = jsonData['record'] as Map<String, dynamic>?;
    
    if (recordData == null) return;

    final record = RealtimeSystemRecord.fromJson(recordData);
    
    switch (action) {
      case 'create':
      case 'update':
        _systems[record.id] = record;
        debugPrint('📡 System ${action}: ${record.name} (CPU: ${record.info.cpu}%, Mem: ${record.info.mp}%)');
        break;
      case 'delete':
        _systems.remove(record.id);
        debugPrint('🗑️ System deleted: ${record.name}');
        break;
    }
    
    _systemsController.add(Map.from(_systems));
  }

  /// Handle alert event
  void _handleAlertEvent(Map<String, dynamic> jsonData) {
    debugPrint('🚨 Alert event: $jsonData');
    _alertsController.add(jsonData);
  }

  /// Subscribe to systems and alerts
  Future<void> _subscribe() async {
    if (_clientId == null) {
      debugPrint('⚠️ Cannot subscribe without client ID');
      return;
    }

    try {
      final token = StorageService.getString('access_token');
      
      final response = await _dio.post(
        '$_baseUrl/realtime',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null && token.isNotEmpty) 'Authorization': token,
          },
        ),
        data: {
          'clientId': _clientId,
          'subscriptions': ['systems/*', 'alerts/*'],
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('✅ Subscribed to systems/* and alerts/*');
      } else {
        debugPrint('⚠️ Subscribe response: ${response.statusCode} ${response.data}');
      }
    } catch (e) {
      debugPrint('❌ Failed to subscribe: $e');
    }
  }

  /// Handle disconnect
  void _handleDisconnect() {
    _isConnected = false;
    _clientId = null;
    _connectionController.add(false);
  }

  /// Disconnect from realtime
  Future<void> disconnect() async {
    debugPrint('🔌 Disconnecting from realtime...');
    await _subscription?.cancel();
    _subscription = null;
    _cancelToken?.cancel('Disconnecting from realtime');
    _cancelToken = null;
    _handleDisconnect();
    _systems.clear();
  }

  /// Reconnect to realtime
  Future<void> reconnect() async {
    await disconnect();
    await Future.delayed(const Duration(seconds: 1));
    await connect();
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _systemsController.close();
    _alertsController.close();
    _connectionController.close();
  }
}

/// Singleton provider for realtime service
final realtimeServiceProvider = Provider<RealtimeService>((ref) {
  // Create a dedicated Dio instance for SSE (without the base interceptors that might interfere)
  final dio = Dio(BaseOptions(
    baseUrl: 'https://beszel.flexipgroup.com/api',
    contentType: 'application/json',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: Duration.zero, // No timeout for SSE stream
  ));
  
  final service = RealtimeService(dio);
  ref.onDispose(() => service.dispose());
  return service;
});

/// Stream provider for realtime systems
final realtimeSystemsProvider = StreamProvider<Map<String, RealtimeSystemRecord>>((ref) {
  final service = ref.watch(realtimeServiceProvider);
  
  // Auto-connect when provider is watched
  if (!service.isConnected) {
    service.connect().catchError((e) {
      debugPrint('❌ Auto-connect failed: $e');
    });
  }
  
  return service.systemsStream;
});

/// Stream provider for connection status
final realtimeConnectionProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(realtimeServiceProvider);
  return service.connectionStream;
});

/// Stream provider for alerts
final realtimeAlertsProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final service = ref.watch(realtimeServiceProvider);
  return service.alertsStream;
});
