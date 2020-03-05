import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treehouse/pages/signIn.dart';
import 'package:treehouse/home.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}


final FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'TreeHouse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: Color(0xFFC0F0E8),
        brightness: Brightness.light,
        primaryColor: Color(0xFFA9C77E),
        canvasColor: Colors.transparent,
        fontFamily: "Open Sans",
      ),
      darktheme: ThemeData(
        hintColor: Color(0xFFC0F0E8),
        brightness: Brightness.light,
        primaryColor: Color(0x4BB2F9FF),
        canvasColor: Colors.transparent,
        fontFamily: "Open Sans",
      ),
      home: new StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Home();
          }
          return LoginRegPage();
        }
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context)=> new Home(),
        '/login': (BuildContext context)=> new LoginRegPage()
      },
    );
  }
}
