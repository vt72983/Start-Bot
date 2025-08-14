import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/token_controller.dart';
import '../features/bot/bot_controller.dart';

Future<void> appStartup(WidgetRef ref) async {
  // Загрузка токена и первая синхронизация статуса, если токен есть
  await ref.read(tokenControllerProvider.notifier).load();
  final token = ref.read(tokenControllerProvider);
  if (token != null && token.isNotEmpty) {
    await ref.read(botControllerProvider.notifier).refreshStatus();
  }
}


