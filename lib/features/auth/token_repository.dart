import '../../core/storage/secure_storage.dart';

class TokenRepository {
  TokenRepository(this._storage);

  final SecureStorage _storage;

  Future<void> save(String token) => _storage.saveToken(token);
  Future<String?> read() => _storage.readToken();
  Future<void> clear() => _storage.clearToken();
}


