import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:treehouse/services/dialog.dart';
import './services/dialog.dart';

class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: _width,

        height: _height,
        color: Colors.lightGreen,

        child: SafeArea(
         child: Padding(
           padding: const EdgeInsets.all(16.0),
           child: Column(
             children: <Widget>[
               SizedBox(height: _height * 0.10),
               Text(
                 "Treehouse",
                 style: TextStyle(fontSize: 44, color: Colors.white),
               ),
               SizedBox(height: _height * 0.10),
               AutoSizeText(
                 "Your Local Network",
                 maxLines: 2,
                 textAlign: TextAlign.center,
                 style: TextStyle(
                   fontSize: 30,
                   color: Colors.white,
                 ),
               ),
               SizedBox(height: _height * 0.15),
               RaisedButton(
                 color: Colors.white,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(30.0)),
                 child: Padding(
                   padding: const EdgeInsets.only(
                     top: 10.0, bottom: 10.0, left: 30.0, right:30.0),
                   child: Text(
                   "Begin",
                     style: TextStyle(
                       color: Colors.black,
                       fontSize: 28,
                       fontWeight: FontWeight.w300,
                     ),
                   ),
                 ),
                 onPressed: (){
                   showDialog(
                     context: context,
                     builder: (BuildContext context) => CustomDialog(
                       title: "Create an account?",
                       description: "Creating an account allows you to upload content to Treehouse's storage that can be viewed later from that location.",
                       buttonText: "Create An Account",
                       buttonRoute: "/signUp",
                     )
                   );
                 },
               ),
               SizedBox(height: _height * 0.05),
               FlatButton(
                 child: Text(
                   "Login",
                   style: TextStyle(
                       color: Colors.black,
                       fontSize:25
                   ),
                 ),
                 onPressed: (){
                    //Navigator.of(context).pushReplacementNamed('/signIn');
                    Navigator.pushReplacementNamed(context, '/signIn');
                 },
               )
             ]
           ),
         )
        )
      ),
    );
  }
}