import 'package:flutter/material.dart';

class Logs extends StatefulWidget {
  Logs({Key? key, required this.data}) : super(key: key);

  Map<int, String> data;

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 100 / 100,
      height: MediaQuery.of(context).size.height * 35 / 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 5 / 100,
            child: Center(
                child: Text("Log",
                    style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.height * 2.5 / 100))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 2.5 / 100,
                horizontal: MediaQuery.of(context).size.width * 2.5 / 100),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.45))),
              height: MediaQuery.of(context).size.height * 20 / 100,
              width: MediaQuery.of(context).size.width * 85 / 100,
              child: Container(
                height: MediaQuery.of(context).size.height * 25 / 100,
                width: 1000,
                child: Scrollbar(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: ClampingScrollPhysics(),
                      child: Scrollbar(
                        scrollbarOrientation: ScrollbarOrientation.right,
                        child: Scrollbar(
                          scrollbarOrientation: ScrollbarOrientation.left,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: IntrinsicWidth(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: buildLogs,
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> get buildLogs {
    print("data: " + widget.data.toString());
    List<Widget> widgets = [];
    widgets.add(Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Theme.of(context).primaryColor.withOpacity(0.6)))),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 25 / 100,
                child: Text("16/05/22 04:27:51")),
            Flexible(
              child: Container(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width * 55 / 100),
                  child: Text("Test")),
            )
          ],
        ),
      ),
    ));
    widget.data.forEach((key, value) {
      print("iterating");
      widgets.add(Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.6)))),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 25 / 100,
                  child: Text(
                      DateTime.fromMillisecondsSinceEpoch(key).toString())),
              Flexible(
                child: Container(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width * 55 / 100),
                    child: Text(value)),
              )
            ],
          ),
        ),
      ));
    });

    return widgets;
  }
}
