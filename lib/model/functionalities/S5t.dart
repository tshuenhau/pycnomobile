import "package:Sensr/model/functionalities/Functionality.dart";

class S5t extends Functionality<double?> {
  S5t(double? value)
      : super(
            name: "70cm",
            key: "S5T",
            unit: "mm",
            color: null,
            icon: null,
            value: value);
}
