import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'token_repository.dart';
import '../../core/storage/secure_storage_provider.dart';

final tokenRepositoryProvider = Provider<TokenRepository>((ref) => TokenRepository(ref.read(secureStorageProvider)));

final tokenControllerProvider = StateNotifierProvider<TokenController, String?>((ref) => TokenController(ref.read(tokenRepositoryProvider))..load());

class TokenController extends StateNotifier<String?> {
  TokenController(this._repository) : super(null);

  final TokenRepository _repository;

  Future<void> load() async {
    state = await _repository.read();
  }

  Future<void> save(String token) async {
    await _repository.save(token);
    state = token;
  }

  Future<void> clear() async {
    await _repository.clear();
    state = null;
  }
}


