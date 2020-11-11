import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduler/createTask.dart';
import 'package:intl/intl.dart';


enum TaskStates{
  WORK_IN_PROGRESS, COMPLETED, CLOSED,  DELETED,  DEADLINE_EXPIRED
}

class Task
{
  static final List<String> statuses = ['Work in Progress', 'Completed', 'Closed', 'Deleted', 'Deadline_expired'];
  var docid = null;
  String taskid = null;
  String taskname = null;
  String taskdesc = null;
  String assignedto = null;
  List<String> cclist = null;
  var deadline = null;
  DateTime dline;

  int status = 0;
  int priority = 1; // Priority range 1-5
  CollectionReference _taskCollection = FirebaseFirestore.instance.collection('task');

  Task(var docid, String name, String desc, String ass, List<String> cc, var deadline, int status){
    print('Creating task');
    this.docid = docid;
    this.taskid = name.hashCode.toString();
    this.taskname = name;
    this.taskdesc = desc;
    this.assignedto = ass;
    this.cclist = cc;
    this.deadline = deadline;
    this.dline = DateTime.parse(deadline);
    if (status == null){
      this.status = 0;
    }
    else{
      this.status = status;
    }
  }
  // updatestatus() async{
  //   Stream<QuerySnapshot> qys = this._taskCollection.
  //   where('deadline', isLessThan: DateTime.now()).get().
  //   whenComplete(() => );
  //
  //
  // }

  String toDate(String deadline){
    DateTime date = DateTime.parse(deadline);
    date = date.toLocal();
    String dt = DateFormat('dd - MMM - yyyy (EEEE)').format(date);

    return dt;
  }
  String statusDefinition(int status){
    return statuses[status].toString();

    // switch(status){
    //   case 0: return 'Task in Progress';
    //   case 1: return 'Task Completed';
    //   case 2: return 'Task Deleted';
    //   case 3: return 'Task Expired';
    //   default: return 'Unknown status: '+status.toString();
    // }
    // return null;
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

  bool saveMe()
  {

    print('Task: Saving my self');

    Map document = {
      'taskid': this.taskname.hashCode.toString(),
      'taskname': this.taskname,
      'taskdesc': this.taskdesc,
      'assignedto': this.assignedto,
      'cclist': this.cclist.toString(),
      'deadline': this.deadline,
      'status': TaskStates.WORK_IN_PROGRESS
    };

    try
    {
      print('Task details:'+document.toString());

      this._taskCollection.add({
        'taskid': this.taskname.hashCode.toString(),
        'taskname': this.taskname,
        'taskdesc': this.taskdesc,
        'assignedto': this.assignedto,
        'cclist': FieldValue.arrayUnion(this.cclist),
        'deadline':this.deadline,
        'status': TaskStates.WORK_IN_PROGRESS.index
      });
      print('Task saved successfully');
      return true;
    }
    catch(e)
    {
      print('Exception raised while saving task!!!'+e.toString());
      return false;
    }

  }

  Future<void> closeme() async
  {

    print('Closing task with id:'+this.docid);
    await this._taskCollection.doc(this.docid).update({'status':2});
    print('Task closed... check after some time');

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

