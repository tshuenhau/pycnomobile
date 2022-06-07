import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:Sensr/model/TimeSeries.dart';

class SensorLineChart extends StatefulWidget {
  SensorLineChart({
    Key? key,
    required this.timeSeries,
  }) : super(key: key);
  final TimeSeries timeSeries;

  @override
  _SensorLineChartState createState() => _SensorLineChartState();
}

class _SensorLineChartState extends State<SensorLineChart> {
  List<FlSpot> _values = const [];
  double _minX = 0;
  double _maxX = 0;
  double _minY = 0;
  double _maxY = 0;
  double _leftTitlesInterval = 0;

  final int _divider = 5; //Old value 25
  final int _leftLabelsCount = 6;

  @override
  void initState() {
    super.initState();
    _prepareData();
  }

  void _prepareData() {
    processData(widget.timeSeries);
    setState(() {});
  }

  void processData(TimeSeries data) {
    print(data.getTimeSeries == null);
    double minY = double.maxFinite;
    double maxY = double.minPositive;
    List<FlSpot> points = [];
    if (data.getTimeSeries != null) {
      data.getTimeSeries!.forEach((key, value) {
        if (value != null) {
          //TODO: Maybe remove this if implemented on logic side
          if (minY > value) {
            minY = value;
          }
          if (maxY < value) {
            maxY = value;
          }
          points.add(new FlSpot(key.toDouble(), value));
        }
      });
      _minX = points.first.x;
      _maxX = points.last.x;
      _minY = (minY / _divider).floorToDouble() * _divider;
      _maxY = (maxY / _divider).ceilToDouble() * _divider;

      applyDefaultAxisScales();

      List<FlSpot> temp = [];
      for (int i = 0; i < points.length; i++) {
        //print(points[i].y >= _minY);
        if (points[i].y >= _minY && points[i].y <= _maxY) {
          temp.add(points[i]);
        }
      }
      _values = temp;

      _leftTitlesInterval =
          ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();
    }
  }

  void applyDefaultAxisScales() {
    if ((widget.timeSeries.getKey == "TEMP") ||
        (widget.timeSeries.getKey == "IT")) {
      _maxY = (50); // no min
    }
    if ((widget.timeSeries.getKey == "HUM") ||
        (widget.timeSeries.getKey == "IH")) {
      _maxY = (110);
      _minY = (10);
    }
    if (widget.timeSeries.getKey == "BAT") {
      _maxY = (4.5);
      _minY = (2.8);
    }
    if ((widget.timeSeries.getKey == "ST") ||
        (widget.timeSeries.getKey == "ST1") ||
        (widget.timeSeries.getKey == "ST2") ||
        (widget.timeSeries.getKey == "ST3") ||
        (widget.timeSeries.getKey == "ST4") ||
        (widget.timeSeries.getKey == "ST5") ||
        (widget.timeSeries.getKey == "ST6")) {
      _maxY = (40);
      _minY = (-3);
    }

    if ((widget.timeSeries.getKey == "SO_20T") ||
        (widget.timeSeries.getKey == "SO_40T") ||
        (widget.timeSeries.getKey == "S1T") ||
        (widget.timeSeries.getKey == "S2T") ||
        (widget.timeSeries.getKey == "S3T") ||
        (widget.timeSeries.getKey == "S4T") ||
        (widget.timeSeries.getKey == "S5T") ||
        (widget.timeSeries.getKey == "S6T") ||
        (widget.timeSeries.getKey == "MM1") ||
        (widget.timeSeries.getKey == "MM2") ||
        (widget.timeSeries.getKey == "MM3") ||
        (widget.timeSeries.getKey == "MM4") ||
        (widget.timeSeries.getKey == "MM5") ||
        (widget.timeSeries.getKey == "MM6")) {
      _maxY = (90);
      _minY = (0);
    }

    if ((widget.timeSeries.getKey == "SO_20") ||
        (widget.timeSeries.getKey == "SO_40") ||
        (widget.timeSeries.getKey == "S1") ||
        (widget.timeSeries.getKey == "S2") ||
        (widget.timeSeries.getKey == "S3") ||
        (widget.timeSeries.getKey == "S4") ||
        (widget.timeSeries.getKey == "S5") ||
        (widget.timeSeries.getKey == "S6")) {
      _maxY = (35000);
      _minY = (26000);
    }

    if (widget.timeSeries.getKey == "NS") {
      _minY = (0);
    }

    if (widget.timeSeries.getKey == "PW") {
      _maxY = (22);
      _minY = (6);
    }

    if ((widget.timeSeries.getKey == "LW") ||
        (widget.timeSeries.getKey == "LW1") ||
        (widget.timeSeries.getKey == "LW2")) {
      _maxY = (1010);
      _minY = (0);
    }

    if ((widget.timeSeries.getKey == "LX1") ||
        (widget.timeSeries.getKey == "LX2")) {
      _maxY = (150000);
      _minY = (0);
    }
  }

  // List<Color> get gradientColors => [
  //       HexColor(widget.timeSeries.getColor).withOpacity(0.65),
  //     ];

  List<Color> gradientColors() {
    Color midPoint = HexColor(widget.timeSeries.getColor);
    int interval = 80;
    int minRed = midPoint.red;
    int maxRed = midPoint.red;

    int minBlue = midPoint.blue;
    int maxBlue = midPoint.blue;

    int minGreen = midPoint.green;
    int maxGreen = midPoint.green;

    if (midPoint.red > 100 &&
        midPoint.red >= midPoint.green &&
        midPoint.red >= midPoint.blue) {
      minRed -= interval;
      maxRed += interval;
    } else if (midPoint.green > 100 &&
        midPoint.green >= midPoint.red &&
        midPoint.green >= midPoint.blue) {
      minGreen -= interval;
      maxGreen += interval;
    } else if (midPoint.blue > 100 &&
        midPoint.blue >= midPoint.red &&
        midPoint.blue >= midPoint.blue) {
      minBlue -= interval;
      maxBlue += interval;
    } else {
      minRed -= interval;
      maxRed += interval;
      minGreen -= interval;
      maxGreen += interval;
      minBlue -= interval;
      maxBlue += interval;
    }

    double midLuminance = 0.2126 * midPoint.red +
        0.7152 * midPoint.green +
        0.0722 * midPoint.blue;
    double minLuminance =
        0.2126 * minRed + 0.7152 * minGreen + 0.0722 * minBlue;
    double maxLuminance =
        0.2126 * maxRed + 0.7152 * maxGreen + 0.0722 * maxBlue;
    int luminanceAdjustment = 60;
    int brightnessAdjustment = 20;

    if (midLuminance > 128 &&
        Theme.of(context).brightness == Brightness.light) {
      // minRed -= brightnessAdjustment;
      // minGreen -= brightnessAdjustment;
      // minBlue -= brightnessAdjustment;
      // maxRed -= brightnessAdjustment;
      // maxGreen -= brightnessAdjustment;
      // maxBlue -= brightnessAdjustment;
      // theme is light mode and graph is too bright
    } else if (midLuminance < 128 &&
        Theme.of(context).brightness == Brightness.dark) {
      // theme is dark mode and graph is too dark

    }
    if (minLuminance < 64) {
      //closer to black
      if (Theme.of(context).brightness == Brightness.dark) {
        minRed += luminanceAdjustment;
        minGreen += luminanceAdjustment;
        minBlue += luminanceAdjustment;
        // minRed += brightnessAdjustment;
        // minGreen += brightnessAdjustment;
        // minBlue += brightnessAdjustment;
        maxRed += brightnessAdjustment;
        maxGreen += brightnessAdjustment;
        maxBlue += brightnessAdjustment;
      }
    } else if (maxLuminance > 192) {
      // closer to white
      if (Theme.of(context).brightness == Brightness.light) {
        maxRed -= luminanceAdjustment;
        maxGreen -= luminanceAdjustment;
        maxBlue -= luminanceAdjustment;
        // minRed -= brightnessAdjustment;
        // minGreen -= brightnessAdjustment;
        // minBlue -= brightnessAdjustment;
        maxRed -= brightnessAdjustment;
        maxGreen -= brightnessAdjustment;
        maxBlue -= brightnessAdjustment;
      }
    }

    Color start =
        Color.fromARGB(200, max(minRed, 0), max(minGreen, 0), max(minBlue, 0));
    Color end = Color.fromARGB(
        200, min(maxRed, 255), min(maxGreen, 255), min(maxBlue, 255));
    return [start, end];
  }

  bool showAvg = false;

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Theme.of(context).colorScheme.primary,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                if (flSpot.x == 0 || flSpot.x == 6) {
                  return null;
                }
                String x = "";
                final DateTime date =
                    DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt());
                if (DateTimeRange(
                            start: DateTime.fromMillisecondsSinceEpoch(
                                _minX.toInt()),
                            end: DateTime.fromMillisecondsSinceEpoch(
                                _maxX.toInt()))
                        .duration
                        .inDays >
                    365 * 6) {
                  x = DateFormat.yMMMd('en_US').format(date);
                }
                x = DateFormat("MMM d", 'en_US').format(date) +
                    ", " +
                    DateFormat("HH:mm", 'en_US').format(date);

                return LineTooltipItem(
                  "${x} \n" + flSpot.y.toStringAsFixed(2),
                  TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            }),
      ),
      gridData: _gridData(),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: _bottomTitles(),
        leftTitles: _leftTitles(),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.55),
              width: 1)),
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY,
      lineBarsData: [
        _lineBarsData(),
      ],
    );
  }

  LineChartBarData _lineBarsData() {
    return LineChartBarData(
      spots: _values,
      isCurved: false,
      colors: gradientColors(),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 2, //! Change dot size here
          color:
              lerpGradient(barData.colors, barData.colorStops!, percent / 100),
          strokeWidth: 0.5, //!Change dot outline size here
          strokeColor: Theme.of(context).colorScheme.primary.withOpacity(0.25),
        ),
      ),
      colorStops: [0.1, 0.4, 0.9],
      belowBarData: BarAreaData(
        show: true,
        colors: gradientColors().map((e) => e.withOpacity(0.35)).toList(),
      ),
    );
  }

  FlGridData _gridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      drawHorizontalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      checkToShowHorizontalLine: (value) {
        return (value - _minY) % _leftTitlesInterval == 0;
      },
    );
  }

  SideTitles _leftTitles() {
    return SideTitles(
      showTitles: true,
      getTextStyles: (context, value) => TextStyle(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
        fontWeight: FontWeight.bold,
        fontSize: MediaQuery.of(context).size.width * 3 / 100,
      ),
      getTitles: (value) {
        //print("Y value: " + value.toString());
        return value.toString();
      },
      reservedSize: MediaQuery.of(context).size.width *
          (_maxY.toString().length > _minY.toString().length ? _maxY : _minY)
              .toString()
              .length /
          50,
      margin: MediaQuery.of(context).size.width * 1.5 / 100,
      interval: max(0.5, _leftTitlesInterval),
    );
  }

  SideTitles _bottomTitles() {
    return SideTitles(
        showTitles: true,
        //reservedSize: 22,
        getTextStyles: (context, value) => TextStyle(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 3 / 100,
            letterSpacing: 0,
            overflow: TextOverflow.clip),
        getTitles: (value) {
          final DateTime date =
              DateTime.fromMillisecondsSinceEpoch(value.toInt());
          if (DateTimeRange(
                      start: DateTime.fromMillisecondsSinceEpoch(_minX.toInt()),
                      end: DateTime.fromMillisecondsSinceEpoch(_maxX.toInt()))
                  .duration
                  .inDays >
              365 * 6) {
            return DateFormat.yMMMd('en_US').format(date);
          }
          // else if (DateTimeRange(
          //             start: DateTime.fromMillisecondsSinceEpoch(_minX.toInt()),
          //             end: DateTime.fromMillisecondsSinceEpoch(_maxX.toInt()))
          //         .duration
          //         .inDays >
          //     1) {
          //   return DateFormat("MMM d").format(date);
          // }

          return DateFormat("MMM d", 'en_US').format(date) +
              "\n" +
              DateFormat("HH:mm", 'en_US').format(date);

          //return dateText;
        },
        margin: MediaQuery.of(context).size.width * 3 / 100,
        interval: max((_maxX - _minX) / 4, 1),
        rotateAngle: 0,
        textAlign: TextAlign.center);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.timeSeries.getName,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 2.5 / 100)),
        SizedBox(
          height: MediaQuery.of(context).size.height * 1 / 100,
        ),
        ((widget.timeSeries.getTimeSeries == null)
            ? Text("-")
            : isLast24()
                ? Text("Last 24 Hours")
                : Text((DateFormat("dd/MM/yy")
                        .format(
                            DateTime.fromMillisecondsSinceEpoch(_minX.toInt()))
                        .toString() +
                    " - " +
                    DateFormat("dd/MM/yy")
                        .format(
                            DateTime.fromMillisecondsSinceEpoch(_maxX.toInt()))
                        .toString()))),
        Stack(
          children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.70,
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                        color: Colors.transparent), //Color(0xff232d37)),
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.height * 3.5 / 100,
                          left: MediaQuery.of(context).size.height * 0.5 / 100,
                          top: MediaQuery.of(context).size.height * 1.5 / 100,
                          bottom:
                              MediaQuery.of(context).size.height * 1.5 / 100),
                      child: widget.timeSeries.getTimeSeries == null
                          ? LineChart(
                              mainData(),
                            )
                          : LineChart(
                              mainData(),
                            ),
                    ),
                  ),
                ),
              ] +
              (widget.timeSeries.getTimeSeries == null
                  ? [
                      AspectRatio(
                        aspectRatio: 1.70,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 3 / 100),
                          child:
                              Container(child: Center(child: Text("No Data"))),
                        ),
                      )
                    ]
                  : []),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 2.5 / 100)
      ],
    );
  }

  bool isLast24() {
    if (DateTime.now().day ==
            DateTime.fromMillisecondsSinceEpoch(_maxX.toInt()).day &&
        DateTimeRange(
                    start: DateTime.fromMillisecondsSinceEpoch(_minX.toInt()),
                    end: DateTime.now())
                .duration
                .inDays <
            1) {
      return true;
    }

    return false;
  }
}

Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors[0];
  }

  if (stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / (colors.length - 1);
      stops.add(percent * index);
    });
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s], rightStop = stops[s + 1];
    final leftColor = colors[s], rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}
