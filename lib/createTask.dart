import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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

// ignore: camel_case_types
class createTask extends State<createTaskForm> {
  final _formkey = GlobalKey<FormState>();
  final _scafkey = GlobalKey<ScaffoldState>();

  TextEditingController _taskNamectrl = new TextEditingController();
  TextEditingController _taskdescctrl = new TextEditingController();

  double spacing = 150.0;

  Task newtask;
  // Task _existingtask = null;
  var _taskName = null;
  var _taskDesc = null;
  var _assignedTo = null;
  List<String> _cclist = [];
  var _selectedccitems = null;
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

    bool deadlineselected = true;
    bool assigned = false;

    var iconcolor = Colors.teal;
    var textcolor = Colors.brown;
    List<DropdownMenuItem> userdropdownmenuitemslist = [];

    return Form(
        key: _formkey,
        child: Scaffold(
          key: _scafkey,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
fillColor: textcolor,
                                  icon: const Icon(FontAwesomeIcons.tasks),

                                  hintText: 'Enter task name',
                                  labelText: 'Enter task name')),
                          SizedBox(width: this.spacing),
                          TextFormField(
                            controller: _taskdescctrl,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Task description missing';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              fillColor: textcolor,
                                focusColor: textcolor,
                                hoverColor: textcolor,
                                icon: const Icon(FontAwesomeIcons.creditCard),
                                hintText: 'Enter task description',
                                labelText: 'Enter task description'),
                            minLines: 1,
                            maxLines: 20,
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
                                for (int i = 0; i < snapshot.data.docs.length; i++)
                                {
                                  DocumentSnapshot snap = snapshot.data.docs[i];

                                  userdropdownmenuitemslist.add(DropdownMenuItem(
                                    child: Text(snap['username'].toString()),
                                    value: snap['userid'].toString(),
                                  ));
                                }

                                return Row(
                                  children: [
                                    Icon(FontAwesomeIcons.user),
                                    SizedBox(width: 20.0),
                                    Expanded(
                                      child: SearchableDropdown.single(
                                        validator: (value){
                                          if(value == null){
                                            return 'Task unassigned!!!';
                                          }
                                        },
                                      isExpanded: true,
                                        hint: 'Choose a user',
                                        searchHint: 'Start typing',
                                        items: userdropdownmenuitemslist,
                                        onChanged: (value){
                                            print('Selected value:'+value.toString())                                       ;
                                            setState(() {
                                              _assignedTo = value;
                                            });
                                      }))
                                  ],
                                );
                              }
                            }),
                          SizedBox(width: this.spacing),
                          Row(
                                    children: [
                                      Icon(FontAwesomeIcons.users),
                                      SizedBox(width: 20.0),
                                      Expanded(
                                          child: SearchableDropdown.multiple(
                                            selectedItems: _selectedccitems,
                                              isExpanded: true,
                                              hint: 'Choose users to be informed',
                                              searchHint: 'Start typing',
                                              items: userdropdownmenuitemslist,

                                              onChanged: (value){
                                                print('Selected value:'+value.toString())                                       ;
                                                for(int i=0; i < value.length;i++){
                                                  String userid = userdropdownmenuitemslist[value[i]].value.toString();
                                                  _cclist.add(userid);
                                                }

                                                setState(() {
                                                  _selectedccitems = value;
                                                  print('Selected userids:'+_cclist.toString());
                                                  print('Selected userids:['+
                                                      _cclist.reduce((value, element) => value+element)+']');
                                                });
                                              }))
                                    ],
                                  ),
                          SizedBox(width: this.spacing),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(FontAwesomeIcons.calendar, color:iconcolor ,),
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
                                    setState(() {
                                        deadlineselected = true;
                                    });
                                  },
                                ),
                                Text(this._deadline!=null ? toDate(this._deadline.toString()):'Not yet selected',

                                    style: TextStyle(color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0))
                              ]),
                          SizedBox(width: this.spacing),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[

                            RaisedButton(
                            child: const Text('Create Task'),
                            onPressed: () {
                              String sbarcontent= '';
                              print('**********************************');
                              print('Task creation started');
                              if (_formkey.currentState.validate() && _validate()){
                                    _saveTask();
                                    sbarcontent = 'Task created succesfully';
                                    _scafkey.currentState.showSnackBar(SnackBar(content: Text(sbarcontent)));
                              }
                              else
                                {
                                   _scafkey.currentState.showSnackBar(SnackBar(
                                    content: Text('Invalid entries')));
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


  bool _validate() {
    print('Validating' + this._assignedTo.toString() + this._deadline.toString());
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

    var taskname = _taskNamectrl.text;
    var taskdesc = _taskdescctrl.text;
    var assignedto = _assignedTo.toString();
    List<String> cclist = _cclist;
    var deadline = _deadline.toString();
    int status = 0;

    String sbarcontent = '';

    newtask = Task(null, taskname, taskdesc, assignedto, cclist, deadline, status);
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

  String toDate(String deadline){
    print('Incoming deadline:'+deadline.toString());
    DateTime date = DateTime.parse(deadline);
    date = date.toLocal();
    String dt = DateFormat('dd - MMM - yyyy (EEEE)').format(date);
    return dt;
  }

}
