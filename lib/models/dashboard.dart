import 'package:firebase_database/firebase_database.dart';

class Dashboard{
  String key;
  String userId;
  String content;
  String posttime;
  Dashboard(this.content, this.posttime, this.userId );

  Dashboard.fromSnapshot(DataSnapshot snapshot) :
      key = snapshot.key,
      userId = snapshot.value["userId"],
      content = snapshot.value["content"],
      posttime = snapshot.value["posttime"];

  toJson(){
    return{
      "content" : content,
      "userId" : userId,
      "posttime" : posttime,
    };
  }
}