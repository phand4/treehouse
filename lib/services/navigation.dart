import 'package:flutter/material.dart';
import 'package:treehouse/pages/option.dart';
import 'package:treehouse/pages/home.dart';
import 'package:treehouse/pages/profile.dart';
import '../services/Provider.dart';

class BottomNavigationBarController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomNavigationBarControllerState();
  }
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {
  int _index = 0;

  final List<Widget> _pages = [
    Home(),
    Profile(),
    Option(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Treehouse"), actions: <Widget>[
        new FlatButton(
          onPressed: () async {
            try {
              await Provider.of(context).auth.signOut();
            } catch (e) {
              print(e);
            }
          },
          child: new Text(
            'Logout',
            style: new TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        )
      ]),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _index,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), title: Text('Profile')),
          BottomNavigationBarItem(
              icon: Icon(Icons.build), title: Text('Options')),
        ],
      ),
    );
  }
}
