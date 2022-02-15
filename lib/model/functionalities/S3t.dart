import "package:pycnomobile/model/functionalities/Functionality.dart";

class S3t extends Functionality<double?> {
  S3t(double? value)
      : super(
            name: "40cm",
            keys: ["S3T"],
            unit: "mm",
            color: null,
            icon: null,
            value: value);
}
