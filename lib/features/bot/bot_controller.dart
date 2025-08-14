import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/secure_storage_provider.dart';
import 'bot_repository.dart';

enum BotStateStatus { unknown, running, stopped, loading, error }

class BotState {
  const BotState({
    required this.status,
    this.message,
  });

  final BotStateStatus status;
  final String? message;

  BotState copyWith({BotStateStatus? status, String? message}) =>
      BotState(status: status ?? this.status, message: message ?? this.message);
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient(secureStorage: ref.read(secureStorageProvider)));
final botRepositoryProvider = Provider<BotRepository>((ref) => BotRepository(ref.read(apiClientProvider)));

final botControllerProvider = StateNotifierProvider<BotController, BotState>((ref) => BotController(ref.read(botRepositoryProvider)));

class BotController extends StateNotifier<BotState> {
  BotController(this._repository) : super(const BotState(status: BotStateStatus.unknown));

  final BotRepository _repository;

  Future<void> init() async {
    // Сначала узнаем текущий статус
    await refreshStatus();
  }

  Future<void> refreshStatus() async {
    state = state.copyWith(status: BotStateStatus.loading, message: null);
    try {
      final running = await _repository.fetchStatus();
      state = state.copyWith(status: running ? BotStateStatus.running : BotStateStatus.stopped);
    } on DioException catch (e) {
      state = state.copyWith(status: BotStateStatus.error, message: _mapError(e));
    } catch (_) {
      state = state.copyWith(status: BotStateStatus.error, message: 'errors.generic');
    }
  }

  Future<void> start() async {
    state = state.copyWith(status: BotStateStatus.loading, message: null);
    try {
      await _repository.start();
      state = state.copyWith(status: BotStateStatus.running);
    } on DioException catch (e) {
      state = state.copyWith(status: BotStateStatus.error, message: _mapError(e));
    }
  }

  Future<void> stop() async {
    state = state.copyWith(status: BotStateStatus.loading, message: null);
    try {
      await _repository.stop();
      state = state.copyWith(status: BotStateStatus.stopped);
    } on DioException catch (e) {
      state = state.copyWith(status: BotStateStatus.error, message: _mapError(e));
    }
  }

  String _mapError(DioException e) {
    final code = e.response?.statusCode;
    if (code == 401) return 'errors.unauthorized';
    if (code == 418) return 'errors.teapot';
    if (code == 408) return 'errors.timeout';
    return 'errors.generic';
  }
}


