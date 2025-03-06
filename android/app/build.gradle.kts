plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Ensure Flutter Plugin is applied last
}

android {
    namespace = "com.example.caterbuddy"
    compileSdk = 34 // Use a hardcoded value instead of flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // Ensure correct NDK version

    defaultConfig {
        applicationId = "com.example.caterbuddy"
        minSdk = 21 // Replace flutter.minSdkVersion with a fixed value
        targetSdk = 34 // Replace flutter.targetSdkVersion with a fixed value
        versionCode = 1 // Replace flutter.versionCode with a fixed value
        versionName = "1.0" // Replace flutter.versionName with a fixed value
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("debug") // Use a proper release signing config
        }
    }
}

flutter {
    source = "../.."
}
