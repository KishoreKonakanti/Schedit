import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scheduler/screens/displaytaskdetails.dart';
import 'package:scheduler/Task.dart';
import 'createTask.dart';
import 'package:scheduler/Users.dart';

class TaskListing extends StatelessWidget {

  final _dbinstance = FirebaseFirestore.instance;
  String _assignedto = null;
  TaskListing(String userid){
    this._assignedto = userid;
    if (userid == null){
      this._assignedto = '';
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Scheduler_TL',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => TaskForm()));
              Navigator.of(context).pushNamed('/createtask');
            },
          ),
          appBar: AppBar(
            title: Text("Task Listing"),
          ),
          body:StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("task").snapshots(),
                      builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                          } else {

                          return ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                  DocumentSnapshot doc = snapshot.data.documents[index];
                                  updateStatus(doc);
                                  return ListTile(
                                      onTap: () {
                                          print('Show task calling!!!');
                                          Task task = this.docToTask(doc);
                                          print('Doc converted to Task...');
                                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                          builder: (context) => displaytaskdetails(
                                          task,
                                          )));
                                      },
                                      title: Text(doc['taskname']),
                                      subtitle: Text(doc['taskdesc']),
                                      trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                        onPressed: ()
                                        {
                                            doc.reference.delete();
                                        },
                                      ),
                              );
                              },
                              );
                          }
                      },
                ),
        ));
  }

  docToTask(DocumentSnapshot doc) {
    print('Converting doc to task');
    Task task;
    if (doc.exists) {
      task = Task(doc.id,doc['taskname'], doc['taskdesc'],
          doc['assignedto'], doc['cclist'], doc['deadline'], doc['status']);

    }
    print('Returning task');
    return task;
  }
  void updateStatus(DocumentSnapshot doc){

  }
}
