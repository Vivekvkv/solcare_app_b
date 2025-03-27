Write-Host "=== BUILDING WITH JAVA 17 ===" -ForegroundColor Cyan

# Store original JAVA_HOME to restore it later
$originalJavaHome = $env:JAVA_HOME

# Set JAVA_HOME to Java 17
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17.0.12"
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

Write-Host "Using Java:" -ForegroundColor Yellow
java -version

# Clean the Flutter project
flutter clean

# Get dependencies
flutter pub get

# Build the APK with verbose logging
Write-Host "=== BUILDING APK... ===" -ForegroundColor Cyan
flutter build apk --release --verbose

# Restore original JAVA_HOME
$env:JAVA_HOME = $originalJavaHome

Write-Host "=== BUILD COMPLETED ===" -ForegroundColor Green
Write-Host "APK is available at build/app/outputs/flutter-apk/app-release.apk" -ForegroundColor Yellow
