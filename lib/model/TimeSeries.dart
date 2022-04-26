enum TYPE_OF_TIMESERIES { SINGLE_SLI, SINGLE_INTERNAL, INTERNAL, SLI, OLD_SLI }

class TimeSeries {
  Map<int, double>? _timeSeries;
  String _color;
  String _name;
  String? _key;
  TimeSeries(
      {required String name,
      required String color,
      String? key,
      required Map<int, double>? timeSeries})
      : _name = name,
        _color = color,
        _key = key,
        _timeSeries = timeSeries;

  String get getName {
    return _name;
  }

  String get getKey {
    return _key!;
  }

  String get getColor {
    return _color;
  }

  Map<int, double>? get getTimeSeries {
    return _timeSeries;
  }

  @override
  String toString() {
    return "color: $_color, key: $_name, data: ${_timeSeries == null}";
  }
}
