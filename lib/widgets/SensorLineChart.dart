import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';

class SensorLineChart extends StatefulWidget {
  SensorLineChart({Key? key, required this.data, required this.function})
      : super(key: key);
  final Map data;
  final Functionality function;
  //? time in milliseconds since 1970 thing: value

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

  final int _divider = 25;
  final int _leftLabelsCount = 6;

  @override
  void initState() {
    super.initState();
    _prepareData();
  }

  void _prepareData() {
    processData(widget.data);
    setState(() {});
  }

  void processData(Map data) {
    double minY = double.maxFinite;
    double maxY = double.minPositive;
    List<FlSpot> points = [];
    data.forEach((key, value) {
      if (minY > value) {
        minY = value;
      }
      if (maxY < value) {
        maxY = value;
      }
      points.add(new FlSpot(key.toDouble(), value));
    });
    _values = points;
    _minX = _values.first.x;
    _maxX = _values.last.x;
    _minY = (minY / _divider).floorToDouble() * _divider;
    _maxY = (maxY / _divider).ceilToDouble() * _divider;
    _leftTitlesInterval =
        ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  LineChartData mainData() {
    return LineChartData(
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
          border: Border.all(color: const Color(0xff37434d), width: 1)),
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
      colors: gradientColors,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 2, //! Change dot size here
          color:
              lerpGradient(barData.colors, barData.colorStops!, percent / 100),
          strokeWidth: 0.5, //!Change dot outline size here
          strokeColor: Colors.black,
        ),
      ),
      colorStops: [0.1, 0.4, 0.9],
      belowBarData: BarAreaData(
        show: true,
        colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
      ),
    );
  }

  FlGridData _gridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: true,
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
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff67727d),
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      getTitles: (value) {
        //print("Y value: " + value.toString());

        return value.toString();
      },
      reservedSize: 32,
      margin: 12,
      interval: _leftTitlesInterval,
    );
  }

  SideTitles _bottomTitles() {
    return SideTitles(
      showTitles: true,
      //reservedSize: 22,
      getTextStyles: (context, value) => TextStyle(
          color: Color(0xff68737d),
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.width * 3.5 / 100,
          letterSpacing: -0.25,
          overflow: TextOverflow.clip),
      getTitles: (value) {
        //print("X value: " + value.toString());

        final DateTime date =
            DateTime.fromMillisecondsSinceEpoch(value.toInt());
        //print(value);
        return DateFormat.Hm().format(date);
      },
      margin: 8,
      interval: (_maxX - _minX) / 6,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            widget.function.name + " (" + widget.function.unit.toString() + ")",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 2.5 / 100)),
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
                      right: MediaQuery.of(context).size.height * 2.5 / 100,
                      left: MediaQuery.of(context).size.height * 1.5 / 100,
                      top: MediaQuery.of(context).size.height * 3.5 / 100,
                      bottom: MediaQuery.of(context).size.height * 1.5 / 100),
                  child: LineChart(
                    mainData(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
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
