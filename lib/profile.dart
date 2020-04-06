import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './services/authentication.dart';
import 'package:treehouse/models/user.dart';
class Profile extends StatefulWidget{
  Profile({Key key, this.auth, this.userId, this.onSignedOut}) : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<User> _userList = [];

  //final realtime.FirebaseDatabase _database = realtime.FirebaseDatabase.instance;

   Query _UserQuery;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0,0.1,0.1,1.0],
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
              Color(0xFFFCFCFF),
              Color(0xFFFCFCFF),
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius:10.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0.5,
                      0.5,
                    ),
                  )
                ],
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                      backgroundImage: null,
                    ),
                  ),
                  SizedBox(
                    width:20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "username",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        "user email",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}