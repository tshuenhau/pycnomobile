# Sensr



## Getting Started



## Package Name/Bundle Identifier

### Android
change package name in build build.gradle

```
defaultConfig {
    applicationId "your.package.name"
    minSdkVersion 16
    targetSdkVersion 27
    versionCode 1
    versionName "1.0"
    testInstrumentationRunner "android.support.test.runner.AndroidJUnitRunner"
}
```

### iOS

Change the bundle identifier from your Info.plist file inside your ios/Runner directory.

```
<key>CFBundleIdentifier</key>
<string>com.your.packagename</string>
```

# Building

### iOS:
<https://docs.flutter.dev/deployment/ios>
### Android:
<https://docs.flutter.dev/deployment/android#build-an-app-bundle>


# View

## Folder Structure
- Each new page is stored in lib/screens
  - Within each screen consists of Widgets & Custom Widgets
- Custom Widgets live in lib/widgets
- For UI elements that require iterating and complex processing, the building of these widgets are abstracted out and put into Builder Functions in lib/builders. These include:
  - All the Sparklin Cards
  - List of Graphs
  - List of Alerts
## Themes & Color Schemes

- Themes and color schemes are located under lib/theme.
- The CustomColorScheme.dart handles the creation of color schemes (default and whitelabelled)
- GlobalTheme.dart is responsible for wrapping the color schemes into ThemeData widgets for further use by the MaterialApp widget.

## Graphs

- Graph styling is located in the SensorLineChart.dart file
- uses fl_chart library to render the graphs in the "All Graphs" page.
- link to the library: <https://pub.dev/packages/fl_chart>
- pre-set axis limits are also located inside under the applyDefaultAxisScales() function.

# Controller


# Model

