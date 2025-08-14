## StartBot (Flutter) — открытый клиент для управления внешним API-ботом

Подробный гайд для GitHub: установка, запуск, конфигурация, структура кода, локализация, обновление документации и интеграция с API.

### Требования
- **Flutter**: 3.19+ (stable)
- **Dart**: 3.3+
- **Android SDK**: 33+

### Быстрый старт
1) Установите зависимости:
```bash
flutter pub get
```
2) Установите базовый URL API:
```dart
// файл: lib/env.dart
class Env {
  static const String apiBaseUrl = 'https://api.example.com';
}
```
3) Запустите приложение:
```bash
flutter run
```

### Конфигурация окружения
- Базовый URL задаётся в `lib/env.dart`.
- Токен API хранится локально в `SecureStorage` и не коммитится.
- Android идентификатор пакета по умолчанию `com.example.startbot`. Меняйте при необходимости в `android/app/build.gradle` (`applicationId`) и `AndroidManifest.xml` (`android:name` у `MainActivity`).

### Интеграция с API
- Авторизация: все запросы отправляются с заголовком `Authorization: Bearer <TOKEN>` если токен сохранён.
- Конечные точки (примерные, для демонстрации):
  - `POST /status` → `{ "running": true|false }`
  - `POST /start` → `{ "status": "started" }`
  - `POST /stop`  → `{ "status": "stopped" }`

Пример клиента см. в `lib/core/network/api_client.dart` и репозитории бота `lib/features/bot/bot_repository.dart`.

### Где брать и как менять токен
- Экран `TokenScreen` позволяет просматривать (замаскировано), сохранять и очищать токен.
- Программно: `TokenRepository.save(token)` / `read()` / `clear()` (`lib/features/auth/token_repository.dart`).

### Структура проекта (главное)
```
lib/
  app/                 — инициализация приложения и роутинг
  core/network/        — HTTP‑клиент (Dio), перехватчики, логирование
  core/storage/        — безопасное хранилище токена
  features/auth/       — работа с токеном
  features/bot/        — вызовы API: /status, /start, /stop
  ui/screens/          — экраны (auth, control, stats, settings, token)
  ui/widgets/          — переиспользуемые виджеты
assets/translations/   — локализация (ru, en)
```

### Локализация
- Файлы переводов лежат в `assets/translations/ru.json` и `assets/translations/en.json`.
- Для добавления нового языка: создайте `xx.json`, пропишите ключи, зарегистрируйте в инициализации локализации.

### Сборка
- Android: `flutter build apk` или `flutter build appbundle`.

#### Тестовый APK (debug)
1) Собрать дебажный APK:
```bash
flutter build apk --debug
```
2) APK будет по пути:
```
build/app/outputs/flutter-apk/app-debug.apk
```
3) Установить на устройство:
```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

#### Тестовый Release APK (без подписи для внутреннего теста)
1) Собрать release APK:
```bash
flutter build apk --release
```
2) Или по ABI (уменьшает размер):
```bash
flutter build apk --release --split-per-abi
```
3) Готовые файлы:
```
build/app/outputs/flutter-apk/app-release.apk
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
build/app/outputs/flutter-apk/app-x86_64-release.apk
```
Примечание: в текущей конфигурации release использует отладочную подпись для упрощённого тестирования. Для продакшена настройте подпись выпусков в `android/app/build.gradle`.

### Вклад (Contributing)
- Форкните репозиторий, создайте ветку от `main`, делайте атомарные PR.
- Перед PR запускайте анализатор: `flutter analyze` и тесты: `flutter test`.

### Лицензия
MIT — используйте свободно с сохранением уведомления об авторстве.
