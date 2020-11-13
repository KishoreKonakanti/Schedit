import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scheduler/Task.dart';
import 'Task.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: TFL()));
}

class TFL extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TF();
  }
}

class TF extends State<TFL>{
  TextEditingController _tfctrl = new TextEditingController();
  List<String> tasks = [];
  String currentsearchtext = '';

  void initState(){
    super.initState();
    _tfctrl.addListener(() {textchanged();});
  }

    @override
  Widget build(BuildContext context) {

    // TODO: implement build
    tasks = [];
    //Populate Tasks
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Function'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          children: [
            TextFormField(
              controller: _tfctrl,

              decoration: InputDecoration(
                hintText: 'Search tasks',
                icon: Icon(FontAwesomeIcons.search),
              ),
              maxLines: 1
            ),

        StreamBuilder(
          stream: FirebaseFirestore.instance.collection("task").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            else {
              return SizedBox(
                height: 200.0,
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    // ignore: missing_return
                    DocumentSnapshot doc = snapshot.data.documents[index];
                    String taskname = doc['taskname'];
                    print('Current taskname:'+taskname);
                    print('Current search text:'+currentsearchtext);
                    if(taskname.contains(currentsearchtext)) {
                      print('Adding task named:' + doc['taskname']);
                      return ListTile(
                        onTap: null,
                        title: Text(doc['taskname']),
                        subtitle: Text(doc['taskdesc'])
                        );
                    }

                  },
                ),
              );
            }
          },
        )]),
      ),
    );
  }

  void textchanged() {
    print('Current text:'+_tfctrl.text);
    print('=======================================');
    print('Filtered tasks:');
    setState(() {
      currentsearchtext = _tfctrl.text;
    });
    tasks.forEach((String taskname) {
      // print(':'+taskname);
      if(taskname.toLowerCase().indexOf(_tfctrl.text.toString().toLowerCase())>=0)
      {
        print(taskname+'\n');
      }
    });
    print('Tasks count:'+tasks.length.toString());
    print('=======================================');
  }

}