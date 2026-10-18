import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/store.dart';
import '../../core/order_engine/order_engine.dart';

/// The store account the Store app is logged into; null shows onboarding (S1).
final storeSessionProvider = NotifierProvider<StoreSession, String?>(StoreSession.new);

class StoreSession extends Notifier<String?> {
  @override
  String? build() => null;

  void logIn(String storeId) => state = storeId;

  void logOut() => state = null;
}

/// The logged-in store. Null when logged out, or when a demo reset removed a store made
/// during the demo (the router then sends the app back to S1).
final currentStoreProvider = Provider<Store?>((ref) {
  final id = ref.watch(storeSessionProvider);
  return ref.watch(orderEngineProvider).stores.where((s) => s.id == id).firstOrNull;
});
