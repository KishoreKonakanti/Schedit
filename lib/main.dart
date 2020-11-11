import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scheduler/TaskListing.dart';
import 'package:scheduler/edittask.dart';
import 'package:scheduler/screens/displaytaskdetails.dart';
import 'package:scheduler/Task.dart';
import 'package:scheduler/usermgmt.dart';
import 'createTask.dart';
import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: TaskListing(null),

  initialRoute: '/',
  routes:<String, WidgetBuilder>{
    '/home': (context) => TaskListing(null),
    '/createtask': (context) => createTaskForm(),
    '/edittask': (context) => edittask(),
    '/users': (context) => usermgmt(),
  }));
}

class TaskList extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String userid = 'raj';
    String username = 'Rajesh';
    Task selectedTask;

    return MaterialApp(
        title: 'Scheduler',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            tooltip: 'Create new task',
            label: Text('Create task'),
            icon: Icon(FontAwesomeIcons.tasks),
            onPressed: () {
              Navigator.of(context).pushNamed('/createtask');
            },
          ),
          appBar: AppBar(
            title: Text("Skanda Task Manager"),
            centerTitle: true,
          ),
          body:
          Center(
            child: Column(
              children: [
                SizedBox(height: 30.0,),
                Text('Tasks assigned to Rajesh',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.brown
                ),),
                SizedBox(height: 30.0,),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("task").where('assignedto', isEqualTo: 'raj').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data.docs[index];
                          return ListTile(
                            onLongPress: (){
                              print('Edit task');
                            },
                            onTap: () {
                              print('Show task calling!!!');
                              selectedTask = this.docToTask(doc);

                              print('Doc converted to Task...');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => displaytaskdetails(
                                            selectedTask,
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
              ],
            ),
          ),
        ));
  }

  docToTask(DocumentSnapshot doc) {
    print('Converting doc to task');
    Task task;
    if (doc.exists)
    {
      task = Task(null, doc['taskname'], doc['taskdesc'],
          doc['assignedto'], doc['cclist'], doc['deadline'], doc['status']);
    }
    else{
      print('Doc doesnt exisits');
      return null;
    }
    print('Returning task');
    return task;
  }
}
