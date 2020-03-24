import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import './services/authentication.dart';
import './services/navigation.dart';
import 'package:treehouse/models/dashboard.dart';
import 'package:geolocator/geolocator.dart';

import 'main.dart';


class Home extends StatefulWidget{
  Home({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);


  final BaseAuth auth;
  final String userId;
  final VoidCallback logoutCallback;
  @override
  State<StatefulWidget> createState() => new _HomeState();
}

class _HomeState extends State<Home>{
  List<Dashboard> _dashboardList = [];

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onDashboardAddedSubscription;
  StreamSubscription<Event> _onDashboardChangedSubscription;
  Query _dashboardQuery;

@override
void initState() {
  super.initState();

  _dashboardList = new List();
  _dashboardQuery = _database
      .reference()
      .child("dashboard")
      .orderByChild("posttime");




  _onDashboardAddedSubscription =
      _dashboardQuery.onChildAdded.listen(_onEntryAdded);
  _onDashboardChangedSubscription =
      _dashboardQuery.onChildChanged.listen(_onEntryChanged);
}



_onEntryAdded(Event event){
    setState(() {
      _dashboardList.add(Dashboard.fromSnapshot(event.snapshot));
    });
}

_onEntryChanged(Event event){
    var oldEntry = _dashboardList.singleWhere((entry){
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _dashboardList[_dashboardList.indexOf(oldEntry)] =
          Dashboard.fromSnapshot(event.snapshot);
    });
}

@override
void dispose(){
    _onDashboardAddedSubscription.cancel();
    _onDashboardChangedSubscription.cancel();
    super.dispose();
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
  showAddDashboardDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
    builder: (BuildContext context){
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    controller: _textEditingController,
                    autofocus: true,
                    decoration: new InputDecoration(
                      labelText: 'Post new content',
                    ),
                  ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: (){
                    Navigator.pop(context);
              }),
              new FlatButton(
                child: const Text('Save'),
                onPressed: (){
                  addNewDashboard(_textEditingController.text.toString());
                  Navigator.pop(context);
                })
            ],
          );
    });
  }

  addNewDashboard(String dashboardItem) async {
  if(dashboardItem.length > 0){
    final FirebaseUser user = await auth.currentUser();
    final userId = user.uid;

    Position location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String formattedLocation = location.toString();
    final formattedLocation2 = RegExp(r"\s");
    var parts = formattedLocation.split(formattedLocation2);
    String lat = parts[1];
    lat = lat.substring(0, lat.length -1);
    String long = parts[3];

   DateTime dateTest = DateTime.now();
   String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss').format(dateTest);
    Dashboard dashboard= new Dashboard(dashboardItem.toString(), formattedDate, userId, lat, long);

    _database.reference().child("dashboard").push().set(dashboard.toJson());
  }
  }

  getlocation() async{
    Position location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String formattedLocation = location.toString();

    return formattedLocation;
  }

  Widget _showDashboardList() {

    if (_dashboardList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _dashboardList.length,
          itemBuilder: (BuildContext context, int index) {
            String dashboardID = _dashboardList[index].key;
            String content = _dashboardList[index].content;
            String postTime = _dashboardList[index].posttime;
            String location = _dashboardList[index].lat;

//            String userId = _dashboardList[index].userId;
            return Dismissible(
                key: Key(dashboardID),
                background: Container(color: Colors.green),
//                onDismissed: (direction) async {
//                  _deleteDashboard(dashboardID, index);
//                },
                child: ListTile(
                  title: Text(
                    '$content',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  subtitle: Text(
                    ' $postTime',
                    style: TextStyle(fontSize: 10.0),
                  ),
                )
            );
          });
    } else {
      return Center(
          child: Text(
            "There is no content in this area. ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0),
          ));
    }
  }
  @override
  Widget build(BuildContext context){
    return new Scaffold(
//      appBar: AppBar(
//        title: Text("dashboard"),
//        actions: <Widget>[
//          new FlatButton(
//            onPressed: signOut(),
//
//            child: new Text('Logout',
//                style: new TextStyle(fontSize:  17.0, color: Colors.white)),
//          )
//        ],
//      ),
      body: _showDashboardList(),
        floatingActionButton: FloatingActionButton(
        onPressed: (){
          showAddDashboardDialog(context);
        },
         tooltip: 'Increment',
          child: Icon(Icons.message),
    ));

  }
}
