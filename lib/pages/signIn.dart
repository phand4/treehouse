import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../services/authentication.dart';
import '../services/Provider.dart';


import 'package:treehouse/pages/option.dart';

enum AuthFormType { signIn, signUp, reset}
//Login + Registration page for the application
class LoginRegPage extends StatefulWidget {
  final AuthFormType authFormType;

  LoginRegPage({Key key, @required this.authFormType}) : super(key: key);

  @override
  _LoginRegPageState createState() =>  _LoginRegPageState(authFormType: this.authFormType);
}


class _LoginRegPageState extends State<LoginRegPage> {
  AuthFormType authFormType;
  String _email, _password, _userName, _warning;
  _LoginRegPageState({this.authFormType});
  final _formKey = GlobalKey<FormState>();

  String _errorMsg;
  bool _loading;

  @override
  void initState() {
    super.initState();
  }

  void _switchForm(String state) {
    _formKey.currentState.reset();
    if(state == "signUp"){
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else if (state == 'home') {
      Navigator.of(context).pop();
    } else {
      setState((){
        authFormType = AuthFormType.signIn;
      });
    }
  }

  //Validation check
  bool _autoValidate() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void _validateAndSubmit() async {
    if (_autoValidate()) {
      try {
        final auth = Provider.of(context).auth;
        switch (authFormType){
          case AuthFormType.signIn:
            await auth.signInWithEmailAndPass(_email, _password);
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.signUp:
            await auth.signUpWithEmailAndPass(_email, _password, _userName);
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.reset:
            await auth.changeEmail(_email);
            setState(() {
              _warning = "A password reset link has been sent to $_email";
              authFormType = AuthFormType.signIn;
            });
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _warning = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blueAccent,
          height: _height,
          width: _width,
          child: Column(
            children: <Widget>[
              SizedBox(height: _height * 0.025),
              showAlert(),
              SizedBox(height: _height * 0.025),
              buildHeaderText(),
              SizedBox(height: _height * 0.05),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: buildInputs() + buildButtons(),
                  )
                )
              )
            ]
          ),
        )
      )
    );
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
          color: Colors.orangeAccent,
          width: double.infinity,
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.error),
              ),
              Expanded(
                child: AutoSizeText(
                  _warning,
                  maxLines: 3,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _warning = null;
                      });
                    },
                  )
              )
            ],
          )
      );
    }
    return SizedBox(
      height: 0,
    );
  }

    AutoSizeText buildHeaderText() {
      String _headerText;
      if(authFormType == AuthFormType.signIn){
        _headerText = "Sign In";
      } else if(authFormType == AuthFormType.reset){
        _headerText = "Reset Password";
      } else {
        _headerText = "Create New Account";
      }
      return AutoSizeText(
        _headerText,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 35,
          color: Colors.white,
        ),
      );
    }

    List<Widget> buildInputs(){
      List<Widget> textFields =[];
      if([AuthFormType.signUp].contains(authFormType)) {
        textFields.add(
            TextFormField(
              validator: NameValidator.validate,
              style: TextStyle(fontSize: 22.0),
              decoration: buildSignUpInputDecoration("Name"),
              onSaved: (value) => _userName = value,
            )
        );
        textFields.add(SizedBox(height: 20));
      }

      textFields.add(
        TextFormField(
          validator: EmailValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration("Email"),
          onSaved: (value) => _email = value,
        ),
      );

      textFields.add(SizedBox(height: 20));
      if(authFormType != AuthFormType.reset){
        textFields.add(
          TextFormField(
            validator: PasswordValidator.validate,
            style: TextStyle(fontSize: 22.0),
            decoration: buildSignUpInputDecoration("Password"),
            obscureText: true,
            onSaved: (value) => _password = value,
          ),
        );
      }
      textFields.add(SizedBox(height: 20));
      return textFields;
    }


    InputDecoration buildSignUpInputDecoration(String hint){
      return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.0)),
        contentPadding:
        const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
      );
    }

    List<Widget> buildButtons(){
    String _switchButtonText, _newFormState, _submitButtonText;
    bool _showForgotPassword = false;
    bool _showSocial = true;

    if(authFormType == AuthFormType.signIn){
      _switchButtonText = "Create New Account";
      _newFormState = "signUp";
      _submitButtonText = "Log In";
      _showForgotPassword = true;
    } else if(authFormType == AuthFormType.reset){
      _switchButtonText = "Return to Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Submit";
    } else {
     _switchButtonText = "Have an Account? Sign In";
     _newFormState = "signIn";
     _submitButtonText = "Sign Up";
    }

    return[
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.white,
          textColor: Colors.blueAccent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _submitButtonText,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            ),
          ),
          onPressed: _validateAndSubmit,
        ),
      ),
      showForgotPassword(_showForgotPassword),
      FlatButton(
        child: Text(
          _switchButtonText,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: (){
          _switchForm(_newFormState);
        },
      ),
    ];
  }

  Widget showForgotPassword(bool visible){
    return Visibility(
      child: FlatButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: (){
          setState((){
            authFormType = AuthFormType.reset;
          });
        },
      ),
      visible: visible,
    );
  }
}


