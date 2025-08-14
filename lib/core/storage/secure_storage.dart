import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage() : _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'api_token';
  static const String _themeModeKey = 'theme_mode'; // system | light | dark
  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> readToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveThemeMode(String mode) async {
    await _storage.write(key: _themeModeKey, value: mode);
  }

  Future<String?> readThemeMode() async {
    return _storage.read(key: _themeModeKey);
  }
}


