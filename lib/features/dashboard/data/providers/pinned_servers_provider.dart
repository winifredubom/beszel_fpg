import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Model for a pinned server
class PinnedServer {
  final String id;
  final String name;

  PinnedServer({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory PinnedServer.fromJson(Map<String, dynamic> json) {
    return PinnedServer(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

/// Notifier for managing pinned servers state
class PinnedServersNotifier extends StateNotifier<List<PinnedServer>> {
  PinnedServersNotifier() : super([]) {
    _loadFromStorage();
  }

  static const String _storageKey = 'pinned_servers';

  /// Load pinned servers from local storage
  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final pinnedIds = prefs.getStringList('${_storageKey}_ids') ?? [];
    final pinnedNames = prefs.getStringList('${_storageKey}_names') ?? [];

    final List<PinnedServer> servers = [];
    for (int i = 0; i < pinnedIds.length && i < pinnedNames.length; i++) {
      servers.add(PinnedServer(id: pinnedIds[i], name: pinnedNames[i]));
    }
    state = servers;
  }

  /// Save pinned servers to local storage
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = state.map((s) => s.id).toList();
    final names = state.map((s) => s.name).toList();
    await prefs.setStringList('${_storageKey}_ids', ids);
    await prefs.setStringList('${_storageKey}_names', names);
  }

  /// Check if a server is pinned
  bool isPinned(String serverId) {
    return state.any((server) => server.id == serverId);
  }

  /// Pin a server
  Future<void> pinServer(String serverId, String serverName) async {
    if (!isPinned(serverId)) {
      state = [...state, PinnedServer(id: serverId, name: serverName)];
      await _saveToStorage();
    }
  }

  /// Unpin a server
  Future<void> unpinServer(String serverId) async {
    state = state.where((server) => server.id != serverId).toList();
    await _saveToStorage();
  }

  /// Toggle pin status
  Future<void> togglePin(String serverId, String serverName) async {
    if (isPinned(serverId)) {
      await unpinServer(serverId);
    } else {
      await pinServer(serverId, serverName);
    }
  }

  /// Clear all pinned servers
  Future<void> clearAllPins() async {
    state = [];
    await _saveToStorage();
  }
}

/// Provider for pinned servers
final pinnedServersProvider =
    StateNotifierProvider<PinnedServersNotifier, List<PinnedServer>>((ref) {
  return PinnedServersNotifier();
});

/// Helper provider to check if a specific server is pinned
final isServerPinnedProvider = Provider.family<bool, String>((ref, serverId) {
  final pinnedServers = ref.watch(pinnedServersProvider);
  return pinnedServers.any((server) => server.id == serverId);
});
