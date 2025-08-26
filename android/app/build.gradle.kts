plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.wonjongseo.jlpt_jonggack"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.wonjongseo.jlpt_jonggack"
        // minSdk = flutter.minSdkVersion
        minSdk = 23
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    android {
        signingConfigs {
            create("release") {
                storeFile = file("../keystore/key.jks")
                val passwordFile = file("../keystore/keystore.password")
                val password = passwordFile.readText().trim()
                storePassword = password
                keyAlias = "key"
                keyPassword = password
            }
        }

        buildTypes {
            getByName("release") {
                isMinifyEnabled = false
                isShrinkResources = false 
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.2.2")
}

flutter {
    source = "../.."
}
