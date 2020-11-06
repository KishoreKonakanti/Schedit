import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/screens/showTask.dart';
import 'package:scheduler/Task.dart';
import 'TaskForm.dart';
//import 'package:scheduler/Users.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //users us = new users();
  // print(us.idtoName("raj"));
  runApp(MaterialApp(home: TaskList(),
  initialRoute: '/',
  routes:<String, WidgetBuilder>{
    '/createtask': (context) => TaskForm(),
    '/edittask': (context) => TaskForm()
  }));
}

class TaskList extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Scheduler',
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
            title: Text("Firestore Demo"),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("task").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = snapshot.data.documents[index];
                    return ListTile(
                      onTap: () {
                        print('Show task calling!!!');
                        Task task = this.docToTask(doc);
                        print('Doc converted to Task...');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => showtask(
                                      task,
                                    )));
                      },
                      title: Text(doc['taskname']),
                      subtitle: Text(doc['taskdesc']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
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
      task = Task(doc['taskname'], doc['taskdesc'],
          doc['assignedTo'], null, null, 0);

    }
    print('Returning task');
    return task;
  }
}
