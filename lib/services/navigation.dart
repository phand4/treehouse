import 'package:flutter/material.dart';
import 'package:treehouse/option.dart';
import 'package:treehouse/home.dart';
import 'package:treehouse/services/authentication.dart';

class BottomNavigationBarController extends StatefulWidget{
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState extends State<BottomNavigationBarController>{
  final List<Widget> pages = [
    Home(
      key: PageStorageKey('Page1'),
    ),
    Option(
      key: PageStorageKey('Page2')
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
    onTap: (int index) => setState(() => _selectedIndex = index),
    currentIndex: selectedIndex,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard), title: Text('Home')),
      BottomNavigationBarItem(
        icon: Icon(Icons.build), title: Text('Options')),
    ],
  );

  @override
  Widget build(BuildContext context){
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}