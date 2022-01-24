import 'package:flutter/material.dart';

class BlankBasicSummaryCard extends StatelessWidget {
  const BlankBasicSummaryCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0,
      child: Card(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1 / 2 - 20,
            height: MediaQuery.of(context).size.height * 1 / 8 - 10,
          )),
    );
  }
}
