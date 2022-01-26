import "package:pycnomobile/model/functionalities/Functionality.dart";

class S123456t extends Functionality<List<Functionality>> {
  S123456t(List<Functionality> value)
      : super(
            name: "Soil moisture",
            key: "S1T, S2T, S3T, S4T, S5T, S6T",
            unit: "mm",
            color: null,
            value: value,
            icon: null);
}
