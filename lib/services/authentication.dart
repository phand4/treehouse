import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
      (FirebaseUser user) => user?.uid,
  );

  Future<String> signInWithEmailAndPass(String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user.uid;
  }

  Future<String> signUpWithEmailAndPass(String email, String password, String name) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    String url = "gs://treehouse-bdeca.appspot.com/users/4333097.jpg";
    await updateUserPhoto(url);
    await updateUserName(name, authResult.user);
    return authResult.user.uid;
  }

  Future updateUserName(String name, FirebaseUser currentUser) async{
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
  }

  Future updateUserPhoto(String url) async{
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.photoUrl = url;
    FirebaseUser currentUser = await getCurrentUser();
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
  }

  Future<String> getCurrentUID() async{
    return (await _firebaseAuth.currentUser()).uid;
  }

  Future getCurrentUser() async {
    return await _firebaseAuth.currentUser();

  }

  Future getCurrentProfilePhoto() async{
    return (await _firebaseAuth.currentUser()).photoUrl;
  }

  Future getCurrentDisplayName() async{
    return (await _firebaseAuth.currentUser()).displayName;
  }

  signOut() async{
    return _firebaseAuth.signOut();
  }

  Future sendEmailVerification() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future changeEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future changePassword(String password) async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.updatePassword(password).then((_) {
      print("Password has been changed successfully.");
    }).catchError((onError) {
      print("Password cannot be changed" + onError.toString());
    });
  }

  Future deleteUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.delete().then((_) {
    print("User deleted");
    }).catchError((onError) {
    print("User may not be deleted" + onError.toString());
    });
    return null;
  }

  Future sendPasswordResetMail(String email) async{
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future getImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
        return image;
    });
  }

}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Display name can't be empty";
    }
    if (value.length < 4) {
      return "Display name must be at least 4 characters long";
    }
    if (value.length > 30) {
      return "Display name must be less than 30 characters long";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}