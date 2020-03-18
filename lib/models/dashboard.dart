import 'package:firebase_database/firebase_database.dart';

class Dashboard{
  String key;
  String userId;
  String content;
  DateTime posttime;
  Dashboard(this.userId, this.content, this.posttime);

  Dashboard.fromSnapshot(DataSnapshot snapshot) :
      key = snapshot.key,
      userId = snapshot.value["userId"],
      content = snapshot.value["content"],
      posttime = snapshot.value["posttime"];

  toJson(){
    return{
      "userId" : userId,
      "content" : content,
      "posttime" : posttime,
    };
  }
}