import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

final pocketBaseProvider = Provider<PocketBase>((ref) {
  final pb = PocketBase('https://beszel.flexipgroup.com');

  // Optional: keep auth alive across hot reloads if you add persistence later
  ref.onDispose(() {
    pb.authStore.clear();
  });

  return pb;
});
