import "package:pycnomobile/model/functionalities/Functionality.dart";

class St135 extends Functionality<List<Functionality>> {
  St135(List<Functionality> value)
      : super(
          name: "Soil temperature",
          keys: ["ST1", "ST3", "ST5"],
          unit: "ºC",
          color: null,
          icon: null,
          value: value,
        );
}
