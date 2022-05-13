import 'package:pycnomobile/model/TimeSeries.dart';

class LogSeries extends TimeSeries {
  Map<int, String>? _logSeries;
  LogSeries(
      {required String name,
      required String? key,
      required Map<int, String>? logSeries})
      : super(name: name, key: key, color: "", timeSeries: null);

  String get getName {
    return super.getName;
  }

  String get getKey {
    return super.getKey;
  }

  Map<int, String>? get getLogSeries {
    return _logSeries;
  }

  @override
  bool isTimeSeries() {
    return false;
  }

  @override
  String toString() {
    return "key: ${super.getName}, data: ${_logSeries == null}";
  }
}
