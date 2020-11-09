import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  db dbaccess = new db();
  var assUser = 'Rajesh';
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
              final sbar = SnackBar(content: Text(dbaccess.fetchdata()));
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

                // StreamBuilder<QuerySnapshot>(
                //   stream: FirebaseFirestore.instance.collection('users').snapshots(),
                //     // ignore: missing_return
                //     builder: (context, snapshot){
                //         // ignore: missing_return
                //         if(!snapshot.hasData){
                //           // ignore: missing_return
                //           print('Has no data');
                //           return Text('Has no data');
                //         }
                //         else
                //           {
                //           // ignore: missing_return, missing_return
                //           //   return Icon(FontAwesomeIcons.users);
                //             //return Text('asdasdas');
                //              return _dropdownbuilder(snapshot.data.docs);
                //         }
                //     })

            ])
      )
      )
    )
  ));
}

Widget _dropdownbuilder(List<QueryDocumentSnapshot> docs) {
  var assignedUser;
  List<DropdownMenuItem> userlist = [];
  print('Got docs:'+docs.toString());
  for(int i = 0; i < docs.length; i++){
    DocumentSnapshot snap = docs[i];
    userlist.add(
        DropdownMenuItem(
            child: Text(snap['username']),
            value: snap['userid'])
    );
  }
  return Expanded(

      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:[
        Icon(FontAwesomeIcons.users),
        SearchableDropdown.single(
            isExpanded: true,
            underline: true,
            items: userlist,
            onChanged: (value){
              assignedUser = value.toString();
              print('Selected user:'+assignedUser);
            },
            hint: Text('Choose a user')
        )])
  );
}

class db{
  final dbinstance = FirebaseFirestore.instance;
  // final CollectionReference tmpdata = dbinstance.collection('tmp');

  db(){
    Firebase.initializeApp();
  }

  String fetchdata() {
    String username = '';
    print('******************************************************');
    print('Here...');
    dbinstance.collection("users").where('userid', isEqualTo: 'raj').get().then((querySnapshot) {
      if(querySnapshot.docs.length == 0){
        username = null;
      }
      querySnapshot.docs.forEach((result) {
        print(result['userid']+'=>'+result['username']);
        username = result['username'];
      });
    });
    print(username+'******************************************************');
    return username;
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

