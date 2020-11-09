import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:scheduler/Task.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskForm extends StatefulWidget {
  Task newTask;
  TaskForm(Task task){
    if (task != null){
      newTask = task;
    }
  }
  @override
  State<TaskForm> createState() {
    // TODO: implement createState
    return TaskState(this.newTask);
  }
}

class TaskState extends State<TaskForm> {
  final _formkey = GlobalKey<FormState>();
  final _scafkey = GlobalKey<ScaffoldState>();

  TextEditingController _taskNamectrl = new TextEditingController();
  TextEditingController _taskdescctrl = new TextEditingController();
  var _users = ['Rajesh', 'KrishnaPriya', 'Amjad', 'CEO', 'CCO'];

  double spacing = 50.0;

  Task _thisTask;
  var _taskName = null;
  var _taskDesc = null;
  var _assignedTo = 'Rajesh';
  var _cclist = null;
  var _deadline = null;

  TaskState(Task thistask){
    if (thistask != null){
      this._thisTask = thistask;
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String title, taskname, taskdesc, assignedto, cclist;
    int status;
    if(this._thisTask == null){
      title = 'Create Task';
      taskname = '';
      taskdesc = '';
      assignedto = '';
      cclist = '';
      status = -1;
    }
    else{
      title = 'Edit Task';
      taskname = this._thisTask.taskname;
      taskdesc = this._thisTask.taskdesc;
      assignedto = this._thisTask.assignedto;
      cclist = this._thisTask.cclist;
      status = this._thisTask.status;
    }
    return Form(
        key: _formkey,
        child: Scaffold(
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
                          getAssignedField(),
                          SizedBox(width: this.spacing),
                          getCCField(),
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
    return MultiSelectFormField(
      title: Text('CC to',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
      required: true,
      leading: Icon(Icons.account_box),
      dataSource: [
        {"display": "Rajesh", "value": "raj"},
        {"display": "Krishna Priya", "value": "kp"},
        {"display": "Amjad", "value": "amj"},
        {"display": "CEO", "value": "ceo"}
      ],
      textField: 'display',
      valueField: 'value',
      okButtonLabel: 'OK',
      cancelButtonLabel: 'Cancel',
      initialValue: _cclist,
      onSaved: (value) {
        setState(() {
          print('Selected values:' + value);
          _cclist = value;
        });
      },
    );
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
    _thisTask = Task(null, taskName, taskDesc, assigned, cclist, deadline, status);
    print('New task created');
    bool saved = _thisTask.saveMe();

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
    Navigator.pop(context);

    return saved;
  }

  Widget getAssignedField() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text('Assign to:',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
      DropdownButton(
          value: _assignedTo,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          items: _users.map((String item) {
            return DropdownMenuItem<String>(child: Text(item), value: item);
          }).toList(),
          onChanged: (value) {
            setState(() {
              this._assignedTo = value.toString();
              print('Assigned to ' + _assignedTo);
            });
          })
    ]);
  }
}
