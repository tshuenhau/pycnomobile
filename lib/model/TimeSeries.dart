class TimeSeries<T> {
  Map<DateTime, T> _timeSeries;
  String _color;
  String _key;
  TimeSeries(
      {required String key,
      required String color,
      required Map<DateTime, T> timeSeries})
      : _key = key,
        _color = color,
        _timeSeries = timeSeries;

  String get key {
    return _key;
  }

  String get color {
    return _color;
  }

  Map<DateTime, T> get timeSeries {
    return _timeSeries;
  }
}
