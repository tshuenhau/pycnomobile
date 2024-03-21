# Sensr for Pycno

Welcome to **Sensr**, an innovative application developed exclusively for [Pycno](https://www.pycno.co), designed to bring precision agriculture to the palm of your hand. Leveraging Pycno's cutting-edge sensor technology, Sensr provides real-time data monitoring, comprehensive analytics, and actionable insights for farmers, agronomists, and agricultural professionals. Experience the power of real-time data, interactive graphs, instant notifications for adverse weather conditions, and insightful summaries directly through your smartphone.

## 🚀 Getting Started

To embark on a journey towards data-driven agriculture with Sensr, ensure you have the Flutter SDK set up on your system. Follow the [official Flutter setup guide](https://docs.flutter.dev/get-started/install) to install Flutter on Mac or Windows PC.

## 📦 Configuration

### Setting Up Your Project

#### Android

1. Navigate to `android/app/build.gradle`.
2. Modify the `applicationId` to your unique package name:

    ```gradle
    defaultConfig {
        applicationId "your.package.name" // Replace with your package name
        minSdkVersion 16
        targetSdkVersion 27
        versionCode 1
        versionName "1.0"
        testInstrumentationRunner "android.support.test.runner.AndroidJUnitRunner"
    }
    ```

#### iOS

1. Open the `Info.plist` file within the `ios/Runner` directory.
2. Update the `CFBundleIdentifier` with your package name:

    ```xml
    <key>CFBundleIdentifier</key>
    <string>com.your.packagename</string> <!-- Replace with your package name -->
    ```

## 🏗 Building & Publishing

Effortlessly build and publish your application with these step-by-step guides:

- **iOS:** [Deploying to iOS Devices](https://docs.flutter.dev/deployment/ios)
- **Android:** [Deploying to Android Devices](https://docs.flutter.dev/deployment/android#build-an-app-bundle)

Key areas include app signing, release builds, and app store deployment.

## 📂 Project Structure

### 🌟 View

- **Folder Structure:** Organized for efficiency.
  - Pages: `lib/screens`
  - Widgets: `lib/widgets`
  - Builder Functions: `lib/builders` for complex UI elements.

### 🎨 Themes & Color Schemes

- Centralized theme management: `lib/theme`.
- Customize themes with `CustomColorScheme.dart`.
- Apply themes globally with `GlobalTheme.dart`.

### 📈 Graphs & Analytics

- Graph styling in `SensorLineChart.dart`, powered by `fl_chart`.
- Real-time data and analytics visualization.

## 🕹 Controller

Control and manage data with precision:

- `TimeSeriesController`: Fetch and process time series data.
- `SparklinesController`: Retrieve sparklines for quick data insights.
- `ListOfSensorsController`: Manage sensor data effectively.

## 📦 Model

Robust data models for scalability:

- Base `Sensor` class with `FixSensor` and `Pulse` subclasses.
- Data models: `TimeSeries` and `LogSeries`.

## 🔧 Others

Environment configurations and API integration:

- `env.dart`: Contains essential environment variables like the API base url.

By harnessing the power of Sensr and Pycno's sensors, stakeholders in the agricultural sector can optimize their practices, ensure sustainable farming, and achieve remarkable improvements in crop yield and health. Welcome to the future of agriculture.
