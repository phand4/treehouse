import 'package:firebase_database/firebase_database.dart';

class User{
  String key;
  String userId;
  String email;
  String displayName;
  String profilePicture;

  User(this.userId, this.email, this.displayName, this.profilePicture );

  User.fromSnapshot(DataSnapshot snapshot) :
      key = snapshot.key,
      userId = snapshot.value["userId"],
      email = snapshot.value["email"],
      displayName = snapshot.value["displayName"],
      profilePicture = snapshot.value["profilePicture"];


  toJson(){
    return{
      "email" : email,
      "userId" : userId,
      "displayName" : displayName,
      "profilePicture" : profilePicture
    };
  }
}