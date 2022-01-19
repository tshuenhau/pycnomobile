import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  const CustomBottomNavigationBar({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.change_history),
          label: 'Today',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.change_history),
          label: 'Sensors',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.change_history),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.change_history),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.change_history),
          label: 'Account',
        ),
      ],
      currentIndex: widget.selectedIndex,
    );
  }
}
