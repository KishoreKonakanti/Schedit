import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scheduler/listtasks.dart';
import 'package:scheduler/screens/displaytaskdetails.dart';
import 'package:scheduler/tmp/utilities.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'task.dart';
import 'package:get/get.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class edittask extends StatefulWidget{
  Task _editableTask;

  edittask({Task task}){
    print('Got Task id:'+task._taskid);
    print('======================================');
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
  int newstatus = 0;

  TextEditingController _tasknamectrl = new TextEditingController();
  TextEditingController _taskdescctrl = new TextEditingController();

  var _cclist;
  var _assignedto;
  int _status;

  edittaskform(editableTask){
    this._thistask = editableTask;
  }

  final _formkey = GlobalKey<FormState>();
  final _scafkey = GlobalKey<ScaffoldState>();
  String _deadlinetext = '';

  @override
  Widget build(BuildContext context) {
    print('==========================================================');
    print('Edit Task: '+ this._thistask._taskname);
    print('==========================================================');
    // TODO: implement build


    this._assignedto = this._thistask._assignedto;
    this._cclist = this._thistask._cclist;
    this._newDeadline = this._thistask._dline;
    this._status = this._thistask.status;

    this._tasknamectrl.text = this._thistask._taskname;
    this._taskdescctrl.text = this._thistask._taskdesc;
    _deadlinetext = this._thistask._deadline;

    List<DropdownMenuItem> userddmenuitemslist = [];

    List<DropdownMenuItem> statuslist = [];

    for(int i= 0; i < Task.statuses.length;i++){
      print('Status:'+Task.statuses[i]+" with value:"+i.toString());
      DropdownMenuItem dditem = DropdownMenuItem(
                                    child: Text(Task.statuses[i]),
                                    value: i);
      statuslist.add(dditem);
    }
    print('Status list:'+statuslist.toString());
    print('Current status value:'+this._status.toString());

    final dbinstance = FirebaseFirestore.instance;

    var tasknamefield =                   TextFormField(
      controller: _tasknamectrl,
      decoration: InputDecoration(
        icon: Icon(FontAwesomeIcons.tasks),
      ),
      validator: (value){
        if(value.isEmpty){
          return 'Task name cannot be blank';
        }
        return null;
      },
    );
    var taskdescfield =                  TextFormField(
      controller: _taskdescctrl,
      maxLength: 500,
      decoration: InputDecoration(
        icon: Icon(FontAwesomeIcons.stream),
      ),
      validator: (value){
        if(value.isEmpty){
          return 'Task description cannot be blank';
        }
        return null;
      },
    );
    var assignedfield =                   StreamBuilder<QuerySnapshot>(
          stream: dbinstance.collection('users').snapshots(),
          builder: (context, snapshot) {
              if (!snapshot.hasData)
              {
                return Text('Unable to load user data... Please try later');
              }
              else
              {

                  for (int i = 0; i < snapshot.data.docs.length; i++)
                  {
                  DocumentSnapshot snap = snapshot.data.docs[i];

                  userddmenuitemslist.add(DropdownMenuItem(
                  child: Text(snap['username'].toString()),
                  value: snap['userid'].toString(),
                  ));
                  }
                  print('Userlist:'+userddmenuitemslist.toString());
                  return Row(
                  children: [
                      Icon(FontAwesomeIcons.user),
                      SizedBox(width: 20.0),
                      Expanded(
                      child: SearchableDropdown.single(
                      validator: (value){
                      if(value == null){
                      return 'Task cannot be unassigned';
                      }
                      },
                      value: this._thistask._assignedto,
                      isExpanded: true,
                      hint: 'Choose a user',
                      searchHint: 'Start typing',
                      items: userddmenuitemslist,
                      onChanged: (value){
                          print('Selected value:'+value.toString())                                       ;
                      }))
                  ],
                  );
          }
    }); // ASSIGNED

    var ccfield =                   StreamBuilder<QuerySnapshot>(
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
    if(this._thistask._cclist.contains(userid)){
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
    selectedItems: selectedusers.length>0?selectedusers:[],
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
    }); //CC Field

    var deadlinefield = Row( //DEADLINE
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
                                  _selectDate(context, this._thistask._dline);
                                  _deadlinetext = this._newDeadline.toString();
                                  print('Setting text here...2');
                                  setState(() {
                                  print('Setting text here...');
                                  _deadlinetext = this._newDeadline.toString();
                                  });
                                  },
                                  ),
                                  Text(this._thistask.toDate('$_deadlinetext'),
                                  style: TextStyle(color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0)
                                  )
                              ]);
    //DEADLINE;
    print('Current status:'+Task.statuses[this._status]);
    var statusfield = Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:
                          [
                                Text(
                                  'Status:',
                                  style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0)
                                ),
                                DropdownButton(
                                    items: statuslist,
                                    onChanged: (value)
                                    {
                                      setState(()
                                      {
                                        newstatus = value as int;
                                        print('Old status:'+this._thistask.status.toString());
                                        this._status = newstatus as int;
                                        print('New status:'+newstatus.toString());
                                        return null;
                                      });
                                    },
                                  value: this._status,
                                )
                          ]);
    return Form(
    key: _formkey,
        child:  Scaffold(
          bottomNavigationBar: BackButton(
            onPressed: (){
              TaskListing('');
            },
          ),
          appBar: AppBar(
            title: Text('Edit Task'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  tasknamefield,
                  taskdescfield,
                  assignedfield,
                  ccfield,
                  deadlinefield,
                  statusfield,
                  RaisedButton(
                      child: Text('Save task'),
                      onPressed: (){
                        if(_formkey.currentState.validate()) {
                          _updateTask();
                          print('Going back to listing tasks');
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                        else{
                          if(_scafkey != null) {
                            _scafkey.currentState.showSnackBar(
                                SnackBar(content: Text(
                                    'Form validation failed')));
                          }
                        }
                      })
                ]
            ),
          )
      ),
    );
  }

  String isnull(var field){
    return field==null?'NULL':'NOT NULL';
  }

  _updateTask()
  {
    print('Trying to update task');
    print('***************************');
    print('Name ctrl:'+isnull(this._tasknamectrl).toString());
    print('Desc ctrl:'+isnull(this._taskdescctrl).toString());
    print('Assigned:'+isnull(this._assignedto).toString());
    print('status:'+isnull(this._status).toString());
    print('deadline:'+isnull(this._newDeadline).toString());
    print('cclist:'+isnull(this._cclist).toString());

    print('Task details:' + this._tasknamectrl.text);
    print('Task Description:' + _taskdescctrl.text);
    print('Assigned to:' + _assignedto.toString());
    print('CCed to:' + (_cclist!=null?_cclist.toString():'None') );
    print('Deadline:' + _newDeadline.toString());
    print('Status:'+this._thistask.statusDefinition(newstatus));

    var taskName = this._tasknamectrl.text;
    var taskDesc = this._taskdescctrl.text;
    var assigned = this._assignedto.toString();
    var cclist = _cclist!=null?_cclist.toString():null;
    var deadline = this._newDeadline.toString();

    String sbarcontent = '';

    print('Populated all fields');

    FirebaseFirestore.instance.collection('task').doc(this._thistask._docid).update({
      'taskname': taskName,
      'taskdesc': taskDesc,
      'assignedto': assigned,
      'cclist': FieldValue.arrayUnion(this._cclist),
      'deadline': deadline,
      'status': newstatus
    });

    if(this._scafkey.currentState != null) {
      this._scafkey.currentState.showSnackBar(SnackBar(
        content: Text('Task updated'), duration: Duration(seconds: 2),));
    }
    print('Task updated');
    Navigator.pushNamed(context, '/home');
  }

  _selectDate(BuildContext context, DateTime current_deadline) async
  {
    this._newDeadline = await showDatePicker(
      context: context,
      initialDate: current_deadline, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    print('Previous deadlintext:'+_deadlinetext);
    _deadlinetext = _newDeadline.toString();
    print('New deadlintext:'+_deadlinetext);
    print('Date selected: ' + _newDeadline.toString());
  }

}