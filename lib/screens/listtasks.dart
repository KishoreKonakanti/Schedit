import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/task.dart';
import 'createTask.dart';
import '../screens/displaytaskdetails.dart';
import '../constants.dart';


class listtasks extends StatefulWidget{
  String _userid = '';
  listtasks(this._userid);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TaskListing(this._userid);
  }
}

class TaskListing extends State<listtasks> {

  String _searchtext = '';
  TextEditingController _searchtextctrl = new TextEditingController();

  final _dbinstance = FirebaseFirestore.instance;
  String _assignedto = null;
  TaskListing(String userid){
    this._assignedto = userid;
    if (userid == null){
      this._assignedto = '';
    }
  }

  void initState(){
    super.initState();
    _searchtextctrl.addListener(() {searchtextchanged();});
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                ListTile(title: Text('Dashboard'), onTap: (){
                  Navigator.pushNamed(context, '/home');
                },),
                ListTile(title: Text('Users'),onTap: (){
                  Navigator.pushNamed(context, '/users');
                },),
                ListTile(title: Text('Dashboard'))
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            tooltip: 'Create new task',
            label: Text('Create task'),
            icon: Icon(FontAwesomeIcons.tasks),
            onPressed: () {
              Navigator.of(context).pushNamed('/createtask');
            },

          ),
          bottomNavigationBar: BackButton(
            onPressed: null,
          ),
          appBar: AppBar(
            title: Text("Task Listing"),
          ),
          body:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                  controller: _searchtextctrl,
                  maxLines: 1,
                  decoration: InputDecoration(
                    icon: Icon(FontAwesomeIcons.search),
                    hintText: 'Search tasks'
                  ),
              ),
              Expanded(
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
                                        String taskid = doc['taskid'];
                                        String assigned = username;
                                        int status = 4;
                                        return Card(
                                            child: ListTile(
                                              title: Column(

                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children:[
                                                    Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(taskname, style: TextStyle(fontSize: 20.0)),
                                                        IconButton
                                                          (
                                                            icon:Icon(Icons.delete),
                                                            onPressed: () async
                                                            {
                                                                await FirebaseFirestore.instance.collection('task').
                                                                          doc(doc.id).update({
                                                                        'status': TaskStatus.DELETED.index.toString()});
                                                            }
                                                          )
                                                          ]
                                                        ),
                                                    Row(children: [Text(taskdesc, style: TextStyle(fontSize: 15.0))]),
                                                    SizedBox(height: 10.0,),
                                                    Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                      children: [Text('Assigned:'+assigned, style: TextStyle(fontSize: 10.0)),
                                                        IconButton(
                                                              icon: Icon(Icons.messenger),
                                                              onPressed: ()
                                                              {
                                                                  Navigator.pushNamed(context, '/chats', arguments: taskid);
                                                              }
                                                        )]
                                                        ),
                                                    SizedBox(width: 20.0,)]
                                              ),
                                            ));
                                      }

                                  );
                                }
                            },
                      ),
              ),
            ],
          ),
        );
  }

  docToTask(DocumentSnapshot doc) {
    print('Converting doc to task');
    Task task;
    if (doc.exists)
    {
      List<String> taskcclist = [];
      print('2222'+doc['cclist'].toString()+ "=>"+ doc['cclist'].length.toString());
      List<dynamic> tcclist = doc['cclist'];
      print('Dynamic works');
      List<String> cclist = tcclist.map((e) => e.toString()).toList();
      print('Converting cclist to List of Strings');
      taskcclist = cclist.map((e) => e.toString()).toList();
      task = Task(doc.id,doc['taskname'], doc['taskdesc'],
          doc['assignedto'], taskcclist, doc['deadline'], doc['status']);

    }
    print('Returning task');
    return task;
  }
  void updateStatus(DocumentSnapshot doc){

  }

  void searchtextchanged() {
    setState(() {
      this._searchtext = _searchtextctrl.text.toLowerCase();
    });
  }
}
