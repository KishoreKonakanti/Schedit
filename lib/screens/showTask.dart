import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Task.dart';

class showtask extends StatelessWidget{
  Task _task;

  showtask(this._task){
    print('Todo');
  }

  Widget styledText(String txt){
    if (txt == null) {
      return null;
    }
    return Text(txt,
    style: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      color: Colors.black
    ),);
  }
  @override
  Widget build(BuildContext context) {
    print('In build function...');

    print('Task Name:'+this._task.taskname);
    print('Description:'+this._task.taskdesc);
    print('AssignedTo:'+this._task.assignedTo);
    // print("CCed to:"+this._task.cc);
    // print("deadline :"+this._task.dline);

    /*
    PreProcess all task details
     */
    String assignedTo, CCList, deadline;
    String taskname = this._task.taskname;
    String taskdesc = this._task.taskdesc;
    assignedTo = 'None';
    if (_task.assignedTo != null) {
      assignedTo = this._task.assignedTo;
    }
    CCList = 'None';
    if (_task.cclist != null){
      CCList = this._task.cclist;
    }
    deadline = 'None';
    if(_task.deadline != null){
      deadline = _task.deadline;
    }

    print('All fields available');
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Scheduler: Task Details'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                styledText('Task Name: '+taskname),
                styledText('Description: '+taskdesc),
                styledText('AssignedTo: '+assignedTo),
                styledText('CC-ed to: '+CCList),
                styledText('Deadline: '+deadline),
                Center(

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    RaisedButton(

                    child: const Text('Update'),
                      onPressed: null),
                   SizedBox(width: 20.0,),
                   RaisedButton(
                      child: const Text('Delete'),
                     onPressed: null)
              ]),
                )
                  ],
            ),
          ),
        ),
      ),
    )
    ;
  }

}