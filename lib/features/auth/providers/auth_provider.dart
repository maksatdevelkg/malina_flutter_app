// lib/infrastructure/local_storage_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malina_flutter_app/core/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


final localStorageProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError(); 
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});
