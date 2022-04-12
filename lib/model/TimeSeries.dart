class TimeSeries {
  Map<int, double>? _timeSeries;
  String _color;
  String _key;
  TimeSeries(
      {required String key,
      required String color,
      required Map<int, double>? timeSeries})
      : _key = key,
        _color = color,
        _timeSeries = timeSeries;

  String get getKey {
    return _key;
  }

  String get getColor {
    return _color;
  }

  Map<int, double>? get getTimeSeries {
    return _timeSeries;
  }

  @override
  String toString() {
    return "color: $_color, key: $_key, data: ${_timeSeries == null}";
  }
}
