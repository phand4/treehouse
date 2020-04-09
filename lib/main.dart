
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treehouse/LoginPage.dart';
import './pages/root_page.dart';
import './services/authentication.dart';
import './services/navigation.dart';
import './services/Provider.dart';
import 'package:treehouse/home.dart';
import './pages/signIn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        title: "Treehouse",
        theme: ThemeData(
            primarySwatch: Colors.lightGreen,
            textTheme: Theme
                .of(context)
                .textTheme
                .apply(
                fontFamily: 'Helvetica'
            )
        ),
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/home' : (BuildContext context) => HomeController(),
          '/signUp' : (BuildContext context) => LoginRegPage(authFormType: AuthFormType.signUp),
          '/signIn' : (BuildContext context) => LoginRegPage(authFormType: AuthFormType.signIn),
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget{
    @override
    Widget build(BuildContext context){
      final AuthService auth = Provider.of(context).auth;
      return StreamBuilder<String>(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            final bool signedIn = snapshot.hasData;
            return signedIn ? BottomNavigationBarController() : LoginPage();
          }
          return CircularProgressIndicator();
        }
      );
    }
  }

