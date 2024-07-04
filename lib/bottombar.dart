import 'package:dailyexpensetracker/bottom_sheet.dart';
import 'package:dailyexpensetracker/home_page.dart';
import 'package:dailyexpensetracker/add_expense.dart';
import 'package:dailyexpensetracker/provider_engine.dart';
import 'package:dailyexpensetracker/statistics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  static const bottomBar = 'Bottom Bar';
  BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final List<Widget> _screenOptions = [
    HomePage(),
    Container(),
    StatisticsPage()
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      _showBottomSheet();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MyBottomSheetContent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBarWidget(_onItemTapped, _selectedIndex),
      backgroundColor: Colors.blueGrey.shade100,
      body: _screenOptions[_selectedIndex],
    );
  }
}

BottomNavigationBar buildBottomNavigationBarWidget(
    Function onTap, int selectedIndex) {
  return BottomNavigationBar(
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home_outlined,
          size: 28,
          color: selectedIndex == 0 ? Colors.black : Colors.black54,
        ),
        activeIcon: Icon(
          Icons.home,
          size: 28,
          color: Colors.black,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Icon(
            Icons.add,
            size: 28,
            color: Colors.white,
          ),
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.bar_chart_outlined,
          size: 28,
          color: selectedIndex == 2 ? Colors.black : Colors.black54,
        ),
        activeIcon: Icon(
          Icons.bar_chart,
          size: 28,
          color: Colors.black,
        ),
        label: 'Statistics',
      ),
    ],
    currentIndex: selectedIndex,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black54,
    backgroundColor: Colors.white, // Background color set to white
    type: BottomNavigationBarType.fixed,
    onTap: (index) {
      onTap(index);
    },
    elevation: 0, // No elevation for a flat design
    selectedLabelStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.black, // Selected label color black
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.black54, // Unselected label color grayish black
    ),
    selectedIconTheme: IconThemeData(
      size: 28,
      color: Colors.black, // Selected icon color black
    ),
    unselectedIconTheme: IconThemeData(
      size: 28,
      color: Colors.black54, // Unselected icon color grayish black
    ),
    showSelectedLabels: true, // Show labels for selected items
    showUnselectedLabels: false, // Show labels for unselected items
    iconSize: 28, // Set a fixed icon size
  );
}
