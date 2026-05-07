plugins {
  id("com.android.application")
  id("kotlin-android")
  id("dev.flutter.flutter-gradle-plugin")
}

// val keystoreProperties = Properties().apply {
//   rootProject.file("key.properties")
//     .takeIf { it.exists() }
//     ?.inputStream()
//     ?.use { load(it) }
// }

android {
    namespace = "com.example.sorteos_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

  defaultConfig {
    applicationId = "com.example.sorteos_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
  }
  compileOptions {
    sourceCompatibility        = JavaVersion.VERSION_11
    targetCompatibility        = JavaVersion.VERSION_11
  }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
  //
//   signingConfigs {
//     create("release") {
//       keyAlias = keystoreProperties["keyAlias"] as String
//       keyPassword = keystoreProperties["keyPassword"] as String
//       storeFile = file(keystoreProperties["storeFile"] as String)
//       storePassword = keystoreProperties["storePassword"] as String
//     }
//   }

//   buildTypes {
//     release {
//       signingConfig = signingConfigs["release"]
//       isMinifyEnabled   = true
//       isShrinkResources = true
//       proguardFiles(
//         getDefaultProguardFile("proguard-android.txt"),
//         "proguard-rules.pro"
//       )
//     }
//     debug {
//       signingConfig = signingConfigs["release"] // o debug si lo prefieres
//     }
//   }

//   splits {
//     abi {
//       isEnable       = true
//       reset()
//       include("armeabi-v7a", "arm64-v8a", "x86_64")
//       isUniversalApk = false
//     }
//   }
}

flutter {
  source = "../.."
}
