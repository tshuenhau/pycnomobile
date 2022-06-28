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

# Controller
- `TimeSeriesController`
    - Contains the functions to retrieve time series data
    - getSingleTimeSeries only gets time series for one functionality
    - getMultiTimeSeries gets all the time series in that sensor
    - Body of these 2 functions may have to change if a new sensor is introduced
    - variable `intConcurrentCount` determines the number of concurrent API calls made to the server.

- `SparklinesController`
    - Contains the functions to retrieve sparklines data
    - `getTimeSeriesForSparklines` is the main function that retrieves all the sparkines from the server. This function contains two functions: `getSliSparklines` and `getNonSliSparklines`
    - `getSliSparklines` gets all the sparklines for the online SLIs in a Pulse
    - `getNonSliSparklines` gets all the sparklines for a sensor. If the sensor is a Pulse, it was get the non-sli sparklines
    - variable `intConcurrentCount` determines the number of concurrent API calls made to the server.

- `ListOfSensorsController`
    - Gets list of sensors from server and stores them into a `List<Sensor>` 
    - Controller also used to sort and search


# Model
- `Sensor` is the parent class and there are 2 children classes `FixSensor` and `Pulse`. `FixSensor` just represents all the sensors that do not have the hot swap capabilities like the Terra. 
- In the future, if you are introducing sensors that have fixed functionality, then you can just use the `FixSensor` class.
- The Pulse has the fields slil, slir and sli, which represents Left SLI, Right SLI and all SLI respectively. These are used to check if an SLI is the current SLI inside the Pulse, or an old one.
- In the future, if you are introducing a sensor that has these fields, then you can use the Pulse class.
- If you are introducing a new type of sensor that doesn't fit into these 2 classes, you would have to create your own new one and have it extend Sensor.

- There are 2 times of data models: `TimeSeries` and `LogSeries`
- Because `LogSeries` were introduced much later into the app development phase, it extends `TimeSeries` just so that the code doesn't break
- In the future, if you have a new type of data model, it is best to just have it extend `TimeSeries` so you don't have to refactor too much code, or you can have a parent class for all the data models
