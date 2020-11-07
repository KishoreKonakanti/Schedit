import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  db dbaccess = new db();
  final List<DropdownMenuItem> items = [];
  items.add(DropdownMenuItem( child: Text('Rajesh'), value: 'raj', ));
  items.add(DropdownMenuItem( child: Text('Krishna'), value: 'kp', ));

  runApp(MaterialApp(
    home: Scaffold(
        body:Container(
      padding: EdgeInsets.all(20.0),
      child:Center(
        child: Column(
          children: [
            RaisedButton(child: const Text('Fetch Data'),
                onPressed:(){
              dbaccess.fetchdata();
            } ),
            RaisedButton(
              child: const Text('Insert Data'),
                onPressed: (){
                  dbaccess.insertdata();
                }
              ),
              RaisedButton(
                  child: const Text('Delete Data'),
              onPressed: (){
  dbaccess.deletedata();
  }),
                RaisedButton(
                child: const Text('Update data'),
                onPressed: () => dbaccess.updatedata()),

            SearchableDropdown.single(
                items: items,
                value: 'raj',
                hint: 'Select one user',
                searchHint: 'Start typing',
                onChanged: (value){
                  print('Selected values:'+value.toString());
                }),
            SearchableDropdown.multiple(
                items: null,
                onChanged: null
            )
            ])
      )
      )
    )
  ));
}

class db{
  final dbinstance = FirebaseFirestore.instance;
  // final CollectionReference tmpdata = dbinstance.collection('tmp');

  db(){
    Firebase.initializeApp();
  }

  fetchdata() {
    print('******************************************************');
    print('Here...');
    dbinstance.collection("tmp").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        // DocumentSnapshot d = result as DocumentSnapshot;
        // print(d.id);
        // print(d.data());
        print(result['tmpid']+'=>'+result['name']);
      });
    });
  }

  insertdata(){
    dbinstance.collection('tmp').add(
      {
        'tmpid':'1',
        'name':'t1'
      }
    );
  }

  updatedata(){
     dbinstance.collection("tmp").where('tmpid', isEqualTo: '3').get().then((querySnapshot) {
       querySnapshot.docs.forEach((result) {
         DocumentSnapshot d = result as DocumentSnapshot;
         d.reference.update({
           'name': 'Updated Name'
         });
       });
     });
     this.fetchdata();
  }

  deletedata(){
    dbinstance.collection("tmp").where('tmpid', isEqualTo: '1').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        DocumentSnapshot d = result as DocumentSnapshot;
        d.reference.delete();
      });
    });
    print('Deleted tmpid of 1');
    this.fetchdata();
  }

}

