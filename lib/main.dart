
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './pages/root_page.dart';
import './services/authentication.dart';
import './services/navigation.dart';

void main() {
  runApp(new MyApp());
}

final FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TreeHouse',
        theme: ThemeData(
          primarySwatch: Colors.green,
//          textTheme: Theme.of(context).textTheme.apply(
//            fontFamily: 'Helvetica'
//          )
        ),
        home: new RootPage(auth: new Auth(),
        ),
    );
  }
}
