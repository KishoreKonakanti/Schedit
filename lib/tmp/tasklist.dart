import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home:
        Scaffold(
          bottomNavigationBar: BackButton(
            onPressed: null,
          ),
          appBar: AppBar(
            title: Text("Task Listing"),
          ),
          body:Padding(
            padding: const EdgeInsets.all(12.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("task").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                else
                {
                  return ListView.builder(

                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data.documents[index];
                      String taskname = doc['taskname'];
                      String taskdesc = doc['taskdesc'];
                      String assigned = 'Rajesh';
                      int status = 4;
                      return Card(
                        color: status==4?Colors.red:Colors.green,
                          child: ListTile(
                        title: Column(

                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:[
                              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [Text(taskname, style: TextStyle(fontSize: 20.0)),
                                Icon(Icons.delete)],),
                              SizedBox(height: 10.0,),
                              Row(children: [Text(taskdesc, style: TextStyle(fontSize: 15.0))]),
                                SizedBox(height: 10.0,),
                              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [Text('Assigned:'+assigned, style: TextStyle(fontSize: 10.0)),
                                Icon(Icons.messenger)],),
                              SizedBox(width: 20.0,)]
                              ),
                        ));
                      }

                  );
                }
              },
            ),
          ),
        ),
        )
    );

}