import "package:Sensr/model/functionalities/Functionality.dart";

class St135 extends Functionality<List<Functionality?>> {
  St135(List<Functionality?> value)
      : super(
          name: "Soil temperature",
          key: "ST135",
          unit: "ºC",
          color: null,
          icon: null,
          value: value,
        );
}
