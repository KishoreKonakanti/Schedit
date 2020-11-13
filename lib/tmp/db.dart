import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';


class db extends StatelessWidget
{
  FirebaseFirestore fstore = FirebaseFirestore.instance;

  // CollectionReference users = FirebaseFirestore.instance.collection('task');
  CollectionReference _taskCollections;
  // ignore: deprecated_member_use
  final databaseReference = Firestore.instance;

  db(){
    _taskCollections = databaseReference.collection('task');
    print('Constructor');

  }
  Future<void> addTask() {
    // Call the user's CollectionReference to add a new user
    return _taskCollections
        .add({
      'full_name': 'asd', // John Doe
      'company': 'asdasd', // Stokes and Sons
      'age': 'asdasdasd' // 42
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  int selectData ()
  {
    Stream<QuerySnapshot> qys = FirebaseFirestore.instance.collection('task').snapshots();
    int doclength = qys.length as int;
    print('Fetching Data....');
    print('Size: '+ doclength.toString());
    return doclength;
  }

  insertData()
  {

  }
  deleteData()
  {

  }
  updateData()
  {

  }
  saveTask(String taskName, String taskDesc, String ass, String CClist, var deadline) async {

}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    int length = selectData();
    return Center(child: Text('# of documents: '+length.toString(),
    style: TextStyle(fontWeight: FontWeight.w500,
        fontSize: 30)));
  }
}

