import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../screens/createTask.dart';
import '../constants.dart';



class Task
{
  static final List<String> statuses = ['Work in Progress', 'Completed', 'Closed', 'Deleted', 'Deadline_expired'];
  var docid;
  String taskid ;
  String taskname ;
  String taskdesc ;
  String assignedto ;
  List<String> cclist ;
  var deadline ;
  DateTime dline;

  int status = 0;
  int priority = 1; // Priority range 1-5
  CollectionReference _taskCollection = FirebaseFirestore.instance.collection('task');

  // Task(this._docid, this._taskname, this._taskdesc, this._assignedto, this._cclist, this._deadline, this.status){
  //   this._dline = DateTime.parse(this._deadline);
  //   if(this.status == null){
  //     this.status = 0;
  //   }
  // }

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


  String toDate(String deadline){
    DateTime date = DateTime.parse(deadline);
    date = date.toLocal();
    String dt = DateFormat('dd - MMM - yyyy (EEEE)').format(date);

    return dt;
  }
  String statusDefinition(int status){
    return statuses[status].toString();
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
      'status': TaskStatus.WORK_IN_PROGRESS
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
        'status': TaskStatus.WORK_IN_PROGRESS.index
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
    await this._taskCollection.doc(this.docid).update({'status':TaskStatus.CLOSED.index.toString()});
    print('Task closed... check after some time');

  }
  Future<void> deleteme() async
  {

    print('Deleting task with id:'+this.docid);
    await this._taskCollection.doc(this.docid).update({'status':TaskStatus.DELETED.index.toString()});
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

