# potolki_mobile

Приложение для рассчёта натяжных потолков

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Build
    
    ```bash 
flutter build apk --release
    ```

```bash
# Установка зависимостей
flutter pub get

# Анализ кода
flutter analyze

# Сборка debug APK
flutter build apk --debug

# Сборка release APK
flutter build apk --release
```
keytool -genkey -v -keystore android/app/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload


