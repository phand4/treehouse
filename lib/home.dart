import 'package:flutter/material.dart';

class Home extends StatelessWidget{
  Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
       title: Text("Dashboard"),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return ListTile(
          title: Text('Main dashboard page'),
          subtitle: Text('placeholder')
        );
      }),
    );
  }
}