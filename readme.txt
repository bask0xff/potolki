ANDROID

Build -> Flutter -> Build App Bundle

F:\Flutter\bin\flutter.bat --no-color build appbundle
Running Gradle task 'bundleRelease'...                             25,9s
√ Built build\app\outputs\bundle\release\app-release.aab (38.8MB)
Process finished with exit code 0

WEB
F:\Flutter\bin\flutter.bat --no-color build web
Compiling lib\main.dart for the Web...
Font asset "MaterialIcons-Regular.otf" was tree-shaken, reducing it from 1645184 to 8972 bytes (99.5% reduction). Tree-shaking can be disabled by providing the --no-tree-shake-icons flag when building your app.
Font asset "CupertinoIcons.ttf" was tree-shaken, reducing it from 257628 to 1472 bytes (99.4% reduction). Tree-shaking can be disabled by providing the --no-tree-shake-icons flag when building your app.
Compiling lib\main.dart for the Web...                             66,2s
√ Built build\web
Process finished with exit code 0


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

