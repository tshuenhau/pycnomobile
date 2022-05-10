enum TYPE_OF_TIMESERIES { SINGLE_SLI, SINGLE_INTERNAL, INTERNAL, SLI, OLD_SLI }

class LogSeries {
  Map<int, String>? _logSeries;
  String _name;
  String? _key;
  LogSeries(
      {required String name, String? key, required Map<int, String>? logSeries})
      : _name = name,
        _key = key,
        _logSeries = logSeries;

  String get getName {
    return _name;
  }

  String get getKey {
    return _key!;
  }

  Map<int, String>? get getLogSeries {
    return _logSeries;
  }

  @override
  String toString() {
    return "key: $_name, data: ${_logSeries == null}";
  }
}
