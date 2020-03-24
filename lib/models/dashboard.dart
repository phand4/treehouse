import 'package:firebase_database/firebase_database.dart';

class Dashboard{
  String key;
  String userId;
  String content;
  String posttime;
  String lat;
  String long;
  Dashboard(this.content, this.posttime, this.userId, this.lat, this.long );

  Dashboard.fromSnapshot(DataSnapshot snapshot) :
      key = snapshot.key,
      userId = snapshot.value["userId"],
      content = snapshot.value["content"],
      posttime = snapshot.value["posttime"],
      lat = snapshot.value["lat"],
      long = snapshot.value["long"];

  toJson(){
    return{
      "content" : content,
      "userId" : userId,
      "posttime" : posttime,
      "lat" : lat,
      "long" : long
    };
  }
}