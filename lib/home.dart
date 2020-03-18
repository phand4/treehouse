import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import './services/authentication.dart';
import './services/navigation.dart';
import 'package:treehouse/models/dashboard.dart';


class Home extends StatefulWidget{
  Home({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);


  final BaseAuth auth;
  final String userId;
  final VoidCallback logoutCallback;
  @override
  State<StatefulWidget> createState() => new _HomeState();
}

class _HomeState extends State<Home>{
  List<Dashboard> _dashboardList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onDashboardAddedSubscription;
  StreamSubscription<Event> _onDashboardChangedSubscription;


@override
void initState() {
  super.initState();

  _dashboardList = new List();
  Query _dashboardQuery = _database
      .reference()
      .child("dashboard")
      .orderByChild("userId")
      .equalTo(widget.userId);
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

  _updateDashboard(Dashboard dashboard){
  if(dashboard != null){
    _database.reference().child("dashboard").child(dashboard.key).set(dashboard.toJson());
  }
  }

  _deleteDashboard(String dashboardID, int index){
  _database.reference().child("dashboard").child(dashboardID).remove().then
    ((_){
      print("Deleted $dashboardID successful");
      setState(() {
        _dashboardList.removeAt(index);
      });
  });
  }

  addNewDashboard(String dashboardItem){
  if(dashboardItem.length > 0){
    Dashboard dashboard= new Dashboard(dashboardItem.toString(), widget.userId, DateTime.now());

    _database.reference().child("dashboard").push().set(dashboard.toJson());
  }
  }

  Widget _showDashboardList(){
    if(_dashboardList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _dashboardList.length,
          itemBuilder: (BuildContext context, int index) {
            String dashboardID = _dashboardList[index].key;
            String content = _dashboardList[index].content;
            DateTime posttime = _dashboardList[index].posttime;
            String formatposttime = DateFormat('yyyy-MM-dd - kk:mm').format(
                posttime);
            String userId = _dashboardList[index].userId;
            return Dismissible(
                key: Key(dashboardID),
                background: Container(color: Colors.green),
                onDismissed: (direction) async {
                  _deleteDashboard(dashboardID, index);
                },
                child: ListTile(
                  title: Text(
                    content,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  trailing: Text(
                    formatposttime,
                    style: TextStyle(fontSize: 10.0),
                  ),
                )
            );
          });
    } else {
      return Center(
        child: Text(
          "There is no content in this area.",
            textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30.0),
        ));
    }
  }

  @override
  Widget build(BuildContext context){

    return new Scaffold(
      appBar: AppBar(
        title: Text("dashboard"),
        actions: <Widget>[
          new FlatButton(
              onPressed: signOut,
              child: new Text('Logout',
              style: new TextStyle(fontSize:  17.0, color: Colors.white)),
          )
        ],
      ),
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