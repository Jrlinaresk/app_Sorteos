plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sorteos_app"
    compileSdk = 35
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.sorteos_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // signingConfigs {
    //     release {
    //         keyAlias keystoreProperties['keyAlias']
    //         keyPassword keystoreProperties['keyPassword']
    //         storeFile file(keystoreProperties['storeFile'])
    //         storePassword keystoreProperties['storePassword']
    //     }
    //     debug {
    //         keyAlias keystoreProperties['keyAlias']
    //         keyPassword keystoreProperties['keyPassword']
    //         storeFile file(keystoreProperties['storeFile'])
    //         storePassword keystoreProperties['storePassword']
    //     }
    // }

    // buildTypes {
    //     release {
    //         // TODO: Add your own signing config for the release build.
    //         // Signing with the debug keys for now, so `flutter run --release` works.
    //         signingConfig = signingConfigs.release
    //         minifyEnabled = true           // activa R8 para eliminar código muerto
    //         shrinkResources = true         // elimina recursos (drawables, strings) no referenciados
    //         }
    //       debug {
    //         // TODO: Add your own signing config for the release build.
    //         // Signing with the debug keys for now, so `flutter run --release` works.
    //         signingConfig = signingConfigs.debug
    //     }
        
    // }
    // splits {
    //     abi { 
    //         enable = true; 
    //         reset(); 
    //         include 'armeabi-v7a','arm64-v8a','x86_64';
    //          universalApk = false 
    //     }
    // }
}

flutter {
    source = "../.."
}
