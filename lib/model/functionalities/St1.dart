import "package:Sensr/model/functionalities/Functionality.dart";

class St1 extends Functionality<double?> {
  St1(double? value)
      : super(
            name: "10cm",
            key: "ST1",
            color: null,
            icon: null,
            value: value,
            unit: 'mm');
}
