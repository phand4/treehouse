import 'package:flutter/material.dart';
import 'package:treehouse/services/Provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future: Provider.of(context).auth.getCurrentUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return profile(context, snapshot);
                      }
                      else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                ]
            )
        )
    );
  }

//  getImage(context){
//     Provider.of(context).auth.getImage();
//     StorageReference storageReference = FirebaseStorage.instance
//         .ref()
//         .child('uploads/${Path.basename(image2.path)}}');
//     StorageUploadTask uploadTask = storageReference.putFile(image2);
//     await uploadTask.onComplete;
//     storageReference.getDownloadURL().then((fileURL) {
//       setState(() {
//         _uploadedFileURL = fileURL;
//       });
//     });
//  }

  Widget profile(context, snapshot) {
    final user = snapshot.data;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Name: ${user.displayName ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Email: ${user.email ?? 'Anonymous'}",
            style: TextStyle(fontSize: 20),),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Joined: ${DateFormat('MM/dd/yyyy').format(
              user.metadata.creationTime)}", style: TextStyle(fontSize: 20),),
        ),

      ],
    );
  }
}


