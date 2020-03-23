import 'package:flutter/material.dart';
import 'package:treehouse/option.dart';
import 'package:treehouse/home.dart';
import 'package:treehouse/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:treehouse/models/dashboard.dart';

class BottomNavigationBarController extends StatefulWidget{
  BottomNavigationBarController({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  final BaseAuth auth;
  final String userId;
  final VoidCallback logoutCallback;
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState extends State<BottomNavigationBarController>{




  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

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
        appBar: AppBar(
        title: Text("dashboard"),
        actions: <Widget>[
          new FlatButton(
            onPressed: signOut,

            child: new Text('Logout',
                style: new TextStyle(fontSize:  17.0, color: Colors.white)),
          )
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}