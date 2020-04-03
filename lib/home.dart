import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './services/authentication.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import './services/navigation.dart';
import 'package:treehouse/models/dashboard.dart';
import 'package:geolocator/geolocator.dart';
import './services/encodeGeoHash.dart';
import 'package:geohash/geohash.dart';
import 'main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

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
  File _image;
  var image;

//
//  final realtime.FirebaseDatabase _database = realtime.FirebaseDatabase.instance;
  final cloudDbReference = Firestore.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
//  StreamSubscription<Event> _onDashboardAddedSubscription;
//  StreamSubscription<Event> _onDashboardChangedSubscription;
//  Query _dashboardQuery;

  //bounding box to calculate area around user
//  Rectangle<T> boundingBox(Rectangle<T> other) {
//    var latmax = max(this.left  this.width, other.left + other.width);
//    var longmax = max(this.top + this.height, other.top + other.height);
//
//    var latmin = min(this.left, other.left);
//    var longmin = min(this.top, other.top);
//
//    return Rectangle<T>(left, top, right - left, bottom - top);
//  }

@override
void initState() {
  super.initState();


  _dashboardList = new List();
//  _dashboardQuery = _database
//      .reference()
//      .child("dashboard")
//      .orderByChild("posttime");
//      .startAt(range.lower)
//      .endAt(range.upper);

//  _onDashboardAddedSubscription =
//      _dashboardQuery.onChildAdded.listen(_onEntryAdded);
//  _onDashboardChangedSubscription =
//      _dashboardQuery.onChildChanged.listen(_onEntryChanged);
}



//_onEntryAdded(Event event){
//    setState(() {
//      _dashboardList.add(Dashboard.fromSnapshot(event.snapshot));
//    });
//}

//_onEntryChanged(realtime.Event event){
//    var oldEntry = _dashboardList.singleWhere((entry){
//      return entry.key == event.snapshot.key;
//    });
//
//    setState(() {
//      _dashboardList[_dashboardList.indexOf(oldEntry)] =
//          Dashboard.fromSnapshot(event.snapshot);
//    });
//}

//@override
//void dispose(){
//    _onDashboardAddedSubscription.cancel();
//    _onDashboardChangedSubscription.cancel();
//    super.dispose();
//  }

   Future getImage() async {
     await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
       setState(() {
         _image = image;
       });
     });
   }
//   var altText;
//   if(image != null){
//     return AlertDialog(
//       content: new Row(
//         children: <Widget>[
//           new Expanded(
//             child: new TextField(
//               controller: _textEditingController,
//               autofocus: true,
//               decoration: new InputDecoration(
//                 labelText: 'Enter descriptive alternative text for the image.',
//               ),
//             ),
//           )
//         ],
//       ),
//         actions: <Widget>[
//         new FlatButton(
//           onPressed: (){
//             return altText = _textEditingController.text.toString();
//             },
//           child: const Text('Save'),
//        ),
//    ]
//     );
//
//   }


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
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: (){
                  getImage();
                },
                child: Icon(Icons.camera_alt),
              ),
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: (){
                    Navigator.pop(context);
              }),
              new FlatButton(
                child: const Text('Save'),
                onPressed: (){
                  addNewDashboard(_textEditingController.text.toString(), _image);
                  Navigator.pop(context);
                }),
            ],
          );
    });
  }

  addNewDashboard(String dashboardItem, File _image) async {
    //Get current user ID
    final FirebaseUser user = await auth.currentUser();
    final userId = user.uid;

    //Upload image retrieve url and assign url to firestore
    File image2 = _image;
    String _uploadedFileURL;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('uploads/${Path.basename(image2.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(image2);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL){
      setState((){
       _uploadedFileURL = fileURL;
      });
    });



    //Get current user's location
    Position location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var geohash = Geohash.encode(location.latitude, location.longitude);
    DateTime dateTest = DateTime.now();
    await cloudDbReference.collection("dashboard")
    .add({
        'content' : dashboardItem,
        'geohash' : geohash,
        'location' : new GeoPoint(location.latitude, location.longitude),
        'posttime' : dateTest,
        'userId' : userId,
        'photo' : _uploadedFileURL,
    });
  }


  Widget _showDashboardList() {
    final f = new DateFormat('yyyy-MM-dd hh:mm');
    return StreamBuilder<QuerySnapshot>(
      stream: cloudDbReference
          .collection("dashboard")
          .orderBy("posttime", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading content...');
        final int messageCount = snapshot.data.documents.length;
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.lightGreen,
          ),
          itemCount: messageCount,
          itemBuilder:(_, int index){
            final DocumentSnapshot document = snapshot.data.documents[index];
            final docID = snapshot.data.documents[index];
            final dynamic content = document['content'];
            final dynamic posttime = document['posttime'];
            if(document['photo'] == null){
              image = 'gs://treehouse-bdeca.appspot.com/uploads/Pure_White_181.jpg';
            } else {
              image = document['photo'];
            }

            DateTime dateTime = posttime.toDate();
            return Container(
                margin: EdgeInsets.all(8.0),
               child: Card(
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                   child: InkWell(
                     onTap:() => print("Test"),
                     child: Column(
                       children: <Widget>[
                       ClipRRect(
                         borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(8.0),
                           topRight: Radius.circular(8.0),
                         ),
                         child: CachedNetworkImage(
                           imageUrl: image,
//                           imageBuilder: (context, imageProvider) => Container(
//                             decoration: BoxDecoration(
//                               image: image
//                             ),
//                           ),
                           placeholder: (context, url) => CircularProgressIndicator(),
                           errorWidget: (context, url, error) => Icon(Icons.error),
                         ),
//                         Image.network(
//                          image,
//                          height: 150,
//                        ),
                       ),
                         ListTile(
                           title: Text(
                             '$content',
                             style: TextStyle(fontSize: 20.0),
                           ),
                           subtitle: Text(
                             dateTime.toString(),
                             style: TextStyle(fontSize: 10.0),
                           ),
                         )
                     ]
                   )
                 )
            ),
            );
          }
        );
      }
      );
}
//          itemBuilder: (_, int index) {




//              return Dismissible(
//                key: ObjectKey(snapshot.data.documents.elementAt(index)),





//            );

//    return ListView.builder(
//        shrinkWrap: true,
//
//        itemCount: _dashboardList.length,
//        itemBuilder: (BuildContext context, int index) {
//          String dashboardID = _dashboardList[index].key;
//          String content = _dashboardList[index].content;
//          String postTime = _dashboardList[index].posttime;
//          String location = _dashboardList[index].lat;
//
////            String userId = _dashboardList[index].userId;
//          return Dismissible(
//              key: Key(dashboardID),
//              background: Container(color: Colors.green),
////                onDismissed: (direction) async {
////                  _deleteDashboard(dashboardID, index);
////                },
//              child: ListTile(
//                title: Text(
//                  '$content',
//                  style: TextStyle(fontSize: 20.0),
//                ),
//                subtitle: Text(
//                  ' $postTime',
//                  style: TextStyle(fontSize: 10.0),
//                ),
//              )
//          );
//        });
//
//  }  } else {
//  return Center(
//  child: Text(
//  "There is no content in this area. ",
//  textAlign: TextAlign.center,
//  style: TextStyle(fontSize: 30.0),
//  ));


  @override
  Widget build(BuildContext context){
    return new Scaffold(
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
