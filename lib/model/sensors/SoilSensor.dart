import 'package:pycnomobile/model/sensors/Sensor.dart';
import 'package:pycnomobile/model/functionalities/Functionality.dart';

/**
 * The parent class of Master Soil Sensor and Node Soil Sensor
 */
abstract class SoilSensor extends Sensor {
  String? txt;
  int? lfreq;
  double? ve;
  double? ns;

  SoilSensor(
      {required TYPE_OF_SENSOR type,
      required String uid,
      required String? name,
      required String? address,
      required String? img,
      required int? epoch,
      required String? site,
      required bool? isLive,
      required int? isLiveHealth,
      required DateTime? isLiveTS,
      required DateTime? updatedAt,
      required DateTime? polledAt,
      required String? soilType,
      required String? readableAgo,
      required String? readableAgoFull,
      required this.txt,
      required this.lfreq,
      required this.ve,
      required this.ns,
      List<Functionality>? functionalities})
      : super(
            type: type,
            uid: uid,
            name: name,
            img: img,
            address: address,
            epoch: epoch,
            site: site,
            isLive: isLive,
            isLiveTS: isLiveTS,
            isLiveHealth: isLiveHealth,
            updatedAt: updatedAt,
            polledAt: polledAt,
            soilType: soilType,
            readableAgo: readableAgo,
            readableAgoFull: readableAgoFull,
            functionalities: functionalities);

  @override
  String toString() {
    return super.toString();
  }
}
