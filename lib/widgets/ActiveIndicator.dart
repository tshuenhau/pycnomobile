import 'package:flutter/material.dart';
import 'package:Sensr/model/sensors/Sensor.dart';

class ActiveIndicator extends StatelessWidget {
  const ActiveIndicator({
    Key? key,
    required this.sensor,
  }) : super(key: key);

  final Sensor sensor;

  final double outerSize = 2.75;
  final double innerSize = 2;

  @override
  Widget build(BuildContext context) {
    IS_ACTIVE isActive = sensor.isActive();
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * outerSize / 100,
          width: MediaQuery.of(context).size.height * outerSize / 100,
          alignment: Alignment.center,
          child: Icon(Icons.circle,
              color: Theme.of(context).colorScheme.surface,
              size: MediaQuery.of(context).size.height * outerSize / 100),
        ),
        Container(
          height: MediaQuery.of(context).size.height * outerSize / 100,
          width: MediaQuery.of(context).size.height * outerSize / 100,
          alignment: Alignment.center,
          child: Icon(Icons.circle,
              color: isActive == IS_ACTIVE.ACTIVE
                  ? Colors.greenAccent.shade700
                  : isActive == IS_ACTIVE.SEMI
                      ? Colors.orangeAccent.shade700
                      : Colors.redAccent.shade700,
              size: MediaQuery.of(context).size.height * innerSize / 100),
        ),
      ],
    );
  }
}
