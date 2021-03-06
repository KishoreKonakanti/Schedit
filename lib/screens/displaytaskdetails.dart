import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'edittask.dart';
import '../models/task.dart';

class displaytaskdetails extends StatelessWidget{
  Task _task;

  displaytaskdetails(Task task){
    this._task = task;
  }

  Widget styledText(String txt)
  {
    if (txt == null) {
      return null;
    }
    return Text(txt,
    style: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: Colors.black
    ),);
  }

  @override
  Widget build(BuildContext context) {
    int numDaysLeft = 0;

    print('In build function...');

    print('CC list:'+this._task.cclist.toString());
    print('Task Name:'+this._task.taskname);
    print('Description:'+this._task.taskdesc);
    print('AssignedTo:'+this._task.assignedto);
    print("deadline :"+this._task.toDate(this._task.deadline));
    print("Status:"+this._task.statusDefinition(this._task.status));
    numDaysLeft = this._task.dline.difference(DateTime.now()).inDays;
    print('# of days left:'+ numDaysLeft.toString());
    /*
    PreProcess all task details
     */

    String assignedto, deadline;
    var CCList;
    String taskname = this._task.taskname;
    String taskdesc = this._task.taskdesc;
    assignedto = 'None';

    if (_task.assignedto != null) {
      assignedto = this._task.assignedto;
    }

    deadline = 'None';
    if(_task.deadline != null){
      deadline = _task.deadline;
    }
    print('DTD: CClist'+this._task.cclist.toString());

    var ccwidget = StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').
        where('userid', whereIn: this._task.cclist).snapshots(),
        builder: (context, snapshot){
          List<String> usernames = [];
          if(!snapshot.hasData){
            return Text('No users cced!!!');
          }
          else{
            for(int i = 0; i < snapshot.data.docs.length; i++)
            {
              DocumentSnapshot snap = snapshot.data.docs[i];
              usernames.add(snap['username']);
            }
            print('CCed usernames:'+usernames.toString()+"::"+this._task.cclist.toString());
            return styledText('CCed user list: '+ (usernames.length==0?'No users cced!!!':usernames.map((e) => e.toString()+", ").toString()));
          }
        });

    print('CC Widget built...');

    var assignedtext = StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').
        where('userid', isEqualTo: this._task.assignedto).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData ||  snapshot.data.docs.length > 1){
            return Text('Error in loading user name');
          }
          else{
            DocumentSnapshot snap = snapshot.data.docs[0];
            return styledText('Assigned to '+snap['username']);
          }
        });

    print('All fields available');

    // TODO: implement build
    return Scaffold(
        bottomNavigationBar: BackButton(
          onPressed: () => Navigator.of(context).pushNamed('/home'),
        ),
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
                assignedtext,
                ccwidget,
                styledText('Deadline: '+this._task.toDate(deadline).toString()),
                styledText('# of days left: '+numDaysLeft.toString()+' days'),
                styledText('Status:'+ ((numDaysLeft>=1)?_task.statusDefinition(this._task.status):'EXPIRED')),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    RaisedButton(
                    child: const Text('Edit'),
                      onPressed: () {
                        // Navigator.pushNamed(context, '/edittask', arguments: this._task.taskid);
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => edittask(task: this._task)
                            )
                        );
                      }),
                   SizedBox(width: 20.0,),
                   RaisedButton(
                      child: const Text('Close Task'),
                     onPressed: () {
                        this._task.closeme();
                        Navigator.pushNamed(context, '/home');
                     })
              ]),
                )
                  ],
            ),
          ),
        ),
      );
  }

}


