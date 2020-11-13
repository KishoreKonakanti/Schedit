import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scheduler/listtasks.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'task.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class edittask extends StatefulWidget{
  Task _editableTask;
  edittask(Task task){
    this._editableTask = task;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return edittaskform(this._editableTask);
  }
}

class edittaskform extends State<edittask>{
  Task _thistask;
  DateTime _newDeadline;
  edittaskform(editableTask){
    this._thistask = editableTask;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String taskname = this._thistask._taskname;
    String taskdesc = this._thistask._taskdesc;
    String assignedto = this._thistask._assignedto;
    List<String> cclist = this._thistask._cclist;
    DateTime current_deadline = this._thistask._dline;
    int status = this._thistask.status;

    TextEditingController tasknamectrl;
    TextEditingController taskdescctrl;
    final dbinstance = FirebaseFirestore.instance;
    return MaterialApp(
      home: Scaffold(
          bottomNavigationBar: BackButton(
            onPressed: (){
              TaskListing('');
            },
          ),
          appBar: AppBar(
            title: Text('Edit Task'),
          ),
          body: Column(
              children:[
                TextFormField(
                  initialValue: taskname,
                  controller: tasknamectrl,
                  validator: (value){
                    if(value.isEmpty){
                      return 'Task name cannot be blank';
                    }
                  },
                ),
                TextFormField(
                  initialValue: taskdesc,
                  controller: taskdescctrl,
                  maxLength: 500,
                  validator: (value){
                    if(value.isEmpty){
                      return 'Task description cannot be blank';
                    }
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: dbinstance.collection('users').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                      {
                        // print('NO User DATA!!!');
                        return Text('Unable to load user data... Please try later');
                      }
                      else
                      {
                        List<DropdownMenuItem> dditems = [];

                        for (int i = 0; i < snapshot.data.docs.length; i++)
                        {
                          DocumentSnapshot snap = snapshot.data.docs[i];

                          dditems.add(DropdownMenuItem(
                            child: Text(snap['username'].toString()),
                            value: snap['userid'].toString(),
                          ));
                        }
                        print('Userlist:'+dditems.toString());
                        return Row(
                          children: [
                            Icon(FontAwesomeIcons.users),
                            SizedBox(width: 20.0),
                            Expanded(
                                child: SearchableDropdown.single(
                                  validator: (value){
                                    if(value == null){
                                      return 'Task cannot be unassigned';
                                    }
                                  },
                                  value: assignedto,
                                    isExpanded: true,
                                    hint: 'Choose a user',
                                    searchHint: 'Start typing',
                                    items: dditems,

                                    onChanged: (value){
                                      print('Selected value:'+value.toString())                                       ;
                                    }))
                          ],
                        );
                      }
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: dbinstance.collection('users').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                      {
                        // print('NO User DATA!!!');
                        return Text('Unable to load user data... Please try later');
                      }
                      else
                      {
                        List<DropdownMenuItem> dditems = [];
                        List<int> selectedusers = [];
                        for (int i = 0; i < snapshot.data.docs.length; i++)
                        {
                          DocumentSnapshot snap = snapshot.data.docs[i];
                          String userid = snap['userid'].toString();
                          if(cclist.contains(userid)){
                            selectedusers.add(i);
                          }
                          dditems.add(DropdownMenuItem(
                            child: Text(snap['username'].toString()),
                            value: snap['userid'].toString(),
                          ));
                        }
                        print('Userlist:'+dditems.toString());
                        print('Selected users:'+selectedusers.toString());
                        return Row(
                          children: [
                            Icon(FontAwesomeIcons.users),
                            SizedBox(width: 20.0),
                            Expanded(
                                child: SearchableDropdown.multiple(
                                    selectedItems: selectedusers,
                                    isExpanded: true,
                                    hint: 'Choose users to be informed',
                                    searchHint: 'Start typing',
                                    items: dditems,
                                    onChanged: (value){
                                      print('Selected value:'+value.toString());
                                    }))
                          ],
                        );
                      }
                    }),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Deadline:',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        tooltip: 'Tap to select deadline',
                        onPressed: () {
                          _selectDate(context, current_deadline);
                        },
                      )
                    ]),

                RaisedButton(
                    child: Text('Save task'),
                    onPressed: (){

                    })
              ]
          )
      ),
    );
  }

  // bool _saveTask() {
  //   print('Trying to save task');
  //   print('Task details:' + _taskNamectrl.text);
  //   print('Task Description:' + _taskdescctrl.text);
  //   print('Assigned to:' + _assignedTo.toString());
  //   print('CCed to:' + _cclist.toString());
  //   print('Deadline:' + _deadline.toString());
  //
  //   var taskName = _taskNamectrl.text;
  //   var taskDesc = _taskdescctrl.text;
  //   var assigned = _assignedTo.toString();
  //   var cclist = _cclist.toString();
  //   var deadline = _deadline.toString();
  //
  //   int status = 0;
  //   String sbarcontent = '';
  //
  //   newtask = Task(null, taskName, taskDesc, assigned, cclist, deadline, status);
  //   print('New task created');
  //   bool saved = newtask.saveMe();
  //
  //   if (saved) {
  //     sbarcontent = 'Task saved successfully';
  //   } else {
  //     sbarcontent =
  //     'Task not saved!!! Try again. If the problem persists, please contact the admin';
  //   }
  //
  //   var sbar = SnackBar(
  //     content: Text(sbarcontent),
  //   );
  //
  //   // Scaffold.of(context).showSnackBar(sbar);
  //   // Navigate to the main screen
  //   Navigator.pushNamed(context, '/home');
  //
  //   return saved;
  // }

  _selectDate(BuildContext context, DateTime current_deadline) async
  {
    this._newDeadline = await showDatePicker(
      context: context,
      initialDate: current_deadline, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    print('Date selected: ' + _newDeadline.toString());
  }

}