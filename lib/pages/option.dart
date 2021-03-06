import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import '../services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import '../services/Provider.dart';

class Option extends StatefulWidget {

  @override
  _OptionState createState() => _OptionState();
}

class _OptionState extends State<Option> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  final TextEditingController _resetPasswordEmailFilter = new TextEditingController();

  String _email = "";
  String _password = "";
  String _resetPasswordEmail = "";
  String _displayName = "";

  String _errorMsg;
  bool _loading;
  bool _obsecure = false;

  _OptionState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
    _resetPasswordEmailFilter.addListener(_resetPasswordEmailListen);
  }

  void _resetPasswordEmailListen() {
    if (_resetPasswordEmailFilter.text.isEmpty) {
      _resetPasswordEmail = "";
    } else {
      _resetPasswordEmail = _resetPasswordEmailFilter.text;
    }
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  final _textEditingController = TextEditingController();

  StreamSubscription<Event> _onToDoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _todoQuery;

  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await Provider.of(context).auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    Provider.of(context).auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resend link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text(
              "Link to verify your account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Widget _showButtonList() {
    return new Container(
      padding: EdgeInsets.all(26.0),
      child: new ListView(
        children: <Widget>[
          _showChangeEmailContainer(),
          new SizedBox(
            height: 40.0,
          ),
          _showChangePasswordContainer(),
          new SizedBox(
            height: 40.0,
          ),
          _showSentResetPasswordEmailContainer(),
          new SizedBox(
            height: 40.0,
          ),
          _removeUserContainer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text('Flutter login demo'),
//        actions: <Widget>[
//          new FlatButton(
//              child: new Text('Logout',
//                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
//              onPressed: _signOut)
//        ],
//      ),
      body: _showButtonList(),
    );
  }

  Widget _showChangeEmailContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(30.0),
        color: Colors.amberAccent,
      ),
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        children: <Widget>[
          new TextFormField(
            controller: _emailFilter,
            decoration: new InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter New Email",
              hintStyle: TextStyle(fontSize: 20.0, color: Colors.black),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
            ),
          ),
          new MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            onPressed: () {
              _changeEmail();
            },
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: Text(
              "Change Email",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _changeEmail() {
    if (_email != null && _email.isNotEmpty) {
      try {
        print("============>" + _email);
        Provider.of(context).auth.changeEmail(_email);
      } catch (e) {
        print("============>" + e);
        setState(() {
          _loading = false;
          _errorMsg = e.message;
        });
      }
    } else {
      print("Email field left empty.");
    }
  }

  void _changePassword() {
    if (_password != null && _password.isNotEmpty) {
      print("============>" + _password);
      Provider.of(context).auth.changePassword(_password);
    } else {
      print("Password field left empty");
    }
  }

  void _removeUser() {
    Provider.of(context).auth.deleteUser();
  }

  void _sendResetPasswordMail() {
    if (_resetPasswordEmail != null && _resetPasswordEmail.isNotEmpty) {
      print("============>" + _resetPasswordEmail);
      Provider.of(context).auth.sendPasswordResetMail(_resetPasswordEmail);
    } else {
      print("Password field is empty");
    }
  }

  _showChangePasswordContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.amberAccent),
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        children: <Widget>[
          new TextFormField(
            controller: _passwordFilter,
            decoration: new InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter new password",
              hintStyle: TextStyle(fontSize: 20.0, color: Colors.black),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
            ),
          ),
          new MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            onPressed: () {
              _changePassword();
            },
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: Text(
              "Change Password",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  _showSentResetPasswordEmailContainer() {
    return Column(
      children: <Widget>[
        new Container(
          child: new TextFormField(
            controller: _resetPasswordEmailFilter,
            decoration: new InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter Email",
              hintStyle: TextStyle(fontSize: 20.0, color: Colors.black),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
            ),
          ),
        ),
        new MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            onPressed: () {
              _sendResetPasswordMail();
            },
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: Text(
              "Send Password Reset Mail",
              textAlign: TextAlign.center,
            )),
      ],
    );
  }

  _removeUserContainer() {
    return Column(
      children: <Widget>[
        new MaterialButton(
          shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () {
            _removeUser();
          },
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          color: Colors.red,
          textColor: Colors.white,
          child: Text(
        "Remove User",
        textAlign: TextAlign.center,
      ),
    ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Warning: You will have to be recently logged in order to delete your account.",
            style: TextStyle(fontSize: 20,),),
        ),
        ]);
  }
}
