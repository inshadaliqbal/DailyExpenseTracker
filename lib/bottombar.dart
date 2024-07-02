import 'package:dailyexpensetracker/bottom_sheet.dart';
import 'package:dailyexpensetracker/home_page.dart';
import 'package:dailyexpensetracker/add_expense.dart';
import 'package:dailyexpensetracker/provider_engine.dart';
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
    Provider.of<MainEngine>(context,listen: false).todaysTransaction();
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBarWidget(_onItemTapped, _selectedIndex),
      backgroundColor: Colors.blueGrey.shade100,
      body: _screenOptions[_selectedIndex],
    );
  }
}
BottomNavigationBar buildBottomNavigationBarWidget(
    Function onTap, int selectedInt) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home_outlined,
          size: 28,
          color: Colors.white70,
        ),
        activeIcon: Icon(
          Icons.home,
          size: 28,
          color: Colors.white,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.add,
          size: 28,
          color: Colors.white70,
        ),
        activeIcon: Icon(
          Icons.add,
          size: 28,
          color: Colors.white,
        ),
        label: 'ADD',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.bar_chart,
          size: 28,
          color: Colors.white70,
        ),
        activeIcon: Icon(
          Icons.bar_chart,
          size: 28,
          color: Colors.white,
        ),
        label: 'Statistics',
      ),

    ],
    currentIndex: selectedInt,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.black54,
    backgroundColor: Color(0xFF35B079),
    type: BottomNavigationBarType.fixed,
    onTap: (index) {
      onTap(index);
    },
    elevation: 0, // No elevation for a flat design
    selectedLabelStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    selectedIconTheme: IconThemeData(
      size: 28,
      color: Colors.black,
    ),
    unselectedIconTheme: IconThemeData(
      size: 28,
      color: Colors.black87,
    ),
    showSelectedLabels: true, // Show labels for selected items
    showUnselectedLabels: false, // Show labels for unselected items
    iconSize: 28, // Set a fixed icon size
  );
}
