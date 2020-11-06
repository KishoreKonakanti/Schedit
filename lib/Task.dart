import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduler/TaskForm.dart';

enum TaskStates{
  WORK_IN_PROGRESS,  CLOSED,  DELETED,  DEADLINE_EXPIRED
}

class Task
{
  String taskid = null;
  String taskname = null;
  String taskdesc = null;
  String assignedTo = null;
  String cclist = null;
  var deadline = null;
  int status = 0;
  int priority = 1; // Priority range 1-5
  CollectionReference _taskCollection = FirebaseFirestore.instance.collection('task');

  Task(String name, String desc, String ass, String cc, var dline, int status){
    print('Creating task');
    this.taskid = name.hashCode.toString();
    this.taskname = name;
    this.taskdesc = desc;
    this.assignedTo = ass;
    this.cclist = cc;
    this.deadline = dline;
    if (status == null){
      this.status = 0;
    }
    else{
      this.status = status;
    }
  }

  String statusDefinition(int status){
    switch(status){
      case 0: return 'Task in Progress';
      case 1: return 'Task Completed';
      case 2: return 'Task Deleted';
    }
    return null;
  }

  String priorityDefinition(int pr){
    switch(pr)
    {
      case 1: return "Urgent";
      case 2: return "High";
      case 3: return "Normal";
      case 4: return "Lazy";
      case 5: return "Before death";
    }
    return null;
  }
  bool saveMe(){
    print('Task: Saving my self');
    print('Details:');
    print(this.taskname+this.taskdesc+this.assignedTo+this.cclist+this.deadline);
    Map document = {
      'taskid': this.taskname.hashCode.toString(),
      'taskname': this.taskname,
      'taskdesc': this.taskdesc,
      'assignedto': this.assignedTo,
      'cclist': this.cclist,
      'deadline': this.deadline,
      'status': TaskStates.WORK_IN_PROGRESS
    };
    try{
      print('Task details:'+document.toString());
      this._taskCollection.add({
        'taskid': this.taskname.hashCode.toString(),
        'taskname': this.taskname,
        'taskdesc': this.taskdesc,
        'assignedto': this.assignedTo,
        'cclist': this.cclist,
        'deadline': this.deadline,
        'status': TaskStates.WORK_IN_PROGRESS.index
      });
      print('Task saved successfully');
      return true;
    }
    catch(e){
      print('Exception raised while saving task!!!'+e.toString());
      return false;
    }
  }

  // bool deleteme(String taskid){
  //   // Get document reference by taskid
  //   //delete by using reference
  //   QuerySnapshot  qy = this._taskCollection.where('taskid', isEqualTo: taskid).snapshots();
  //             where('taskid', isEqualTo: taskid).snapshots() as QuerySnapshot;
  //
  //   qy.forEach(DocumentSnapshot doc).map(
  //     doc.ref.delete();
  //   )
  //
  // }
}

