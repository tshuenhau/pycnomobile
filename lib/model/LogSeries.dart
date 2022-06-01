import 'package:Sensr/model/TimeSeries.dart';

class LogSeries extends TimeSeries {
  Map<int, String>? _logSeries;
  LogSeries({
    required Map<int, String> logSeries,
    required String name,
    required String? key,
  })  : _logSeries = logSeries,
        super(name: name, key: key, color: "", timeSeries: null);

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
    return "key: ${super.getName}, data: ${_logSeries}";
  }
}
