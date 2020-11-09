import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:scheduler/Task.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import 'Users.dart';

class createTaskForm extends StatefulWidget {
  // Task _newtask;
  // Task _existingtask;
  // createTaskForm(Task task){
  //   if(task != null){
  //     this._existingtask = task;
  //   }
  // }
  @override
  State<createTaskForm> createState() {
    // TODO: implement createState
    return createTask();
  }
}

class createTask extends State<createTaskForm> {
  final _formkey = GlobalKey<FormState>();
  final _scafkey = GlobalKey<ScaffoldState>();

  TextEditingController _taskNamectrl = new TextEditingController();
  TextEditingController _taskdescctrl = new TextEditingController();

  double spacing = 50.0;

  Task newtask;
  // Task _existingtask = null;
  var _taskName = null;
  var _taskDesc = null;
  var _assignedTo = 'Rajesh';
  var _cclist = null;
  var _deadline = null;
  int status = 0;
  
  List<DropdownMenuItem> _userlist;
  final dbinstance = FirebaseFirestore.instance;
  // createTask(Task task){
  //   this._existingtask = task;
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    String title, taskname, taskdetails, assignedto, cclist, deadline;
    int status;

    // if(this._existingtask != null){
    //   title = 'Edit Task';
    //   taskname = this._existingtask.taskname;
    //   taskdetails = this._existingtask.taskdesc;
    //   assignedto = this._existingtask.assignedto;
    //   cclist = this._existingtask.cclist;
    //   deadline = this._existingtask.deadline;
    //   status = this._existingtask.status;
    // }
    // else{
    //   title = 'Create task';
    //
    // }
    return Form(
        key: _formkey,
        child: Scaffold(
          bottomNavigationBar: BackButton(
            onPressed: ()=> Navigator.of(context).pushNamed('/home'),
          ),
            appBar: AppBar(
              title: Text('Create Task'),
            ),
            body: Center(
                child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextFormField(
                              controller: _taskNamectrl,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return ('Please enter a taskname!!!');
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  icon: const Icon(Icons.title),
                                  hintText: 'Enter task name',
                                  labelText: 'Enter task name')),
                          SizedBox(width: this.spacing),
                          TextFormField(
                            controller: _taskdescctrl,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                icon: const Icon(Icons.web_asset),
                                hintText: 'Enter task description',
                                labelText: 'Enter task description'),
                            minLines: 1,
                            maxLines: 5,
                            maxLength: 500,
                          ),
                          SizedBox(width: this.spacing),
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
                          SizedBox(width: this.spacing),
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
                                          child: SearchableDropdown.multiple(
                                              isExpanded: true,
                                              hint: 'Choose users to be informed',
                                              searchHint: 'Start typing',
                                              items: dditems,
                                              onChanged: (value){
                                                print('Selected value:'+value.toString())                                       ;
                                              }))
                                    ],
                                  );
                                }
                              }),
                          SizedBox(width: this.spacing),
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
                                    _selectDate(context);
                                  },
                                )
                              ]),
                          SizedBox(width: this.spacing),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[

                            RaisedButton(
                            child: const Text('Create Task'),
                            onPressed: () {
                              print('**********************************');
                              print('Task creation started');
                              if (_formkey.currentState.validate()) {
                                // final snackbar = SnackBar(content: Text('Saving Data'));
                                // _scafkey.currentState
                                //     .showSnackBar(snackbar);
                                // Scaffold.of(context)
                                //     .showSnackBar(SnackBar(content: Text('Saving Data'),));
                                _saveTask();
                                print('Task creation completed... Popping the screen');

                              } else {
                                print('Form validation failed');
                                // Scaffold.of(context).showSnackBar(SnackBar(
                                //   content: Text('Form Validation failed'),
                                // ));
                                //print('Form Validation failed'),));
                              }
                            },
                          ),
                            RaisedButton(
                              child: Text('Cancel'),
                                onPressed: () => Navigator.of(context).pushNamed('/home'))]

                        )
    ]
    )
    )
    )
    )
    );
  }

  Widget getCCField() {
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
    child: SearchableDropdown.multiple(
    isExpanded: true,
    hint: 'Choose a user',
    searchHint: 'Start typing',
    items: dditems,
    onChanged: (value){
    print('Selected value:'+value.toString()); ;
    }
    )
    )
    ],
    );
    }
        });
  }


  bool _validate() {
    print('Validating' + this._assignedTo + this._deadline);
    if (this._assignedTo == null || this._deadline == null) {
      print('Form validate failed');
      return false;
    }
    print('Form validate success');
    return true;
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1

      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != _deadline)
      setState(() {
        _deadline = picked;
      });
    print('Date selected: ' + _deadline.toString());
  }

  bool _saveTask() {
    print('Trying to save task');
    print('Task details:' + _taskNamectrl.text);
    print('Task Description:' + _taskdescctrl.text);
    print('Assigned to:' + _assignedTo.toString());
    print('CCed to:' + _cclist.toString());
    print('Deadline:' + _deadline.toString());

    var taskName = _taskNamectrl.text;
    var taskDesc = _taskdescctrl.text;
    var assigned = _assignedTo.toString();
    var cclist = _cclist.toString();
    var deadline = _deadline.toString();

    int status = 0;
    String sbarcontent = '';

    newtask = Task(null, taskName, taskDesc, assigned, cclist, deadline, status);
    print('New task created');
    bool saved = newtask.saveMe();

    if (saved) {
      sbarcontent = 'Task saved successfully';
    } else {
      sbarcontent =
          'Task not saved!!! Try again. If the problem persists, please contact the admin';
    }

    var sbar = SnackBar(
      content: Text(sbarcontent),
    );

    // Scaffold.of(context).showSnackBar(sbar);
    // Navigate to the main screen
    Navigator.pushNamed(context, '/home');

    return saved;
  }

  Widget getAssignedField() {
    print('*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+');
    print('My user list: ' + this._userlist.toString());
    List<DropdownMenuItem> userlists = [];

    return StreamBuilder<QuerySnapshot>(
        stream: dbinstance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
          {
            print('NO User DATA!!!');
            return Text('Unable to load user data... Please try later');
          }
          else
            {
            List<DropdownMenuItem> userlist = [];
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              DocumentSnapshot snap = snapshot.data.docs[i];
              userlist.add(DropdownMenuItem(
                child: snap['username'],
                value: snap['userid'],
              ));
            }
            return DropdownButton(items: userlist,
                onChanged: (value) {
                  print('Selected value:' + value.toString());
                });
          }
        });
  }
}
