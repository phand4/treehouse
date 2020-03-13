import 'package:flutter/material.dart';
import '../services/authentication.dart';

import 'package:treehouse/customTextField.dart';
import 'package:treehouse/home.dart';


//Login + Registration page for the application
class LoginRegPage extends StatefulWidget {

  LoginRegPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginRegPageState();
}

//Manages screen state
enum FormMode {LOGIN, SIGNUP}

class _LoginRegPageState extends State<LoginRegPage> {

  String _email, _password, _userName;
  FormMode _formMode = FormMode.LOGIN;
  String _errorMsg;
  bool _loading;

  //Validation check
  bool _autoValidate(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PersistentBottomSheetController _sheetController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _validateAndSubmit() async {
    setState(() {
      _errorMsg = "";
      _loading = true;
    } );
    if(_autoValidate()) {
      String userId= "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _loading = false;
        });

        if( userId.length > 0 && userId != null && _formMode == FormMode.LOGIN){
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState((){
          _loading = false;
          _errorMsg = e.message;
        });
      }
    }
  }

  @override
  void initState(){
    _errorMsg = "";
    _loading = false;
    super.initState();
  }

  void _changeFormToSignup() {
    _formKey.currentState.reset();
    _errorMsg = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin(){
    _formKey.currentState.reset();
    _errorMsg = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context){
    Color primaryColor = Theme.of(context).primaryColor;
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          _showBody(),
          _showCircularProgress(),
        ],
      ));
  }

  Widget _showCircularProgress(){
   if(_loading) {
     return Center(child: CircularProgressIndicator());
   } return Container(height: 0.0, width: 0.0);
  }

  Widget _showVerifyEmailSentDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("A Link to verify your account has been sent to your email"),
        actions: <Widget>[
          new FlatButton(onPressed: () {
            child: new Text("Dismiss"),
            _changeFormToLogin();
            Navigator.of(context).pop();
            },
          ),
          ],
        );
      },
    );
  }

  Widget _showBody(){
    return new Container(
      child: Padding(
        padding: EdgeInsets.only(top: 120),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 240,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                _showEmailInput(),
                _showPasswordInput(),
                _showPrimaryButton(),
                _showSecondaryButton(),
                _showErrorMessage(),
              ],
            )
        ),
      ),
    );
  }

  Widget _showErrorMessage(){
    if(_errorMsg.length > 0 && _errorMsg != null) {
      return new Text(
        _errorMsg,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300),
        );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showEmailInput(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(

    ),
    );
  }

  Widget _showPasswordInput(){

  }

  Widget _showSecondaryButton(){

  }

  Widget _showPrimaryButton(){

  }
}


