import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scheduler/screens/displaytaskdetails.dart';
import 'package:contact_picker/contact_picker.dart';

class usermgmt extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return usermgmtstate();
  }
}

class usermgmtstate extends State<usermgmt>{
  final ContactPicker _contactPicker = new ContactPicker();
  Contact _contact;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          tooltip: 'Create new user',
          label: Text('Add user'),
          icon: Icon(Icons.contacts),
          onPressed: () async {
            Contact selectedcontact = await _contactPicker.selectContact();
            setState(() {
              _contact = selectedcontact;
              print('Selected contact:'+_contact.toString());
              String number = _contact.phoneNumber.number;
              // Remove + sign
              if (number.contains('+')){
                number=number.replaceFirst('+', '');
              }
              String username = _contact.fullName;
              username = username.replaceAll(' ', '_');
              print('++++++++++++++++++++++++++++++++++++++++++++++++++');
              print('Adding user details:'+number+":>"+username);
              print('++++++++++++++++++++++++++++++++++++++++++++++++++');
              FirebaseFirestore.instance.collection('users').add({
                'username': username,
                'userid': number
              });
            });
          },
        ),

        appBar: AppBar(
          title: Text('User List'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Text('No users added');
            }
            else{
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index){
                    DocumentSnapshot doc = snapshot.data.docs[index];
                    return ListTile(
                      onTap: () {
                        print('Show task calling!!!');
                        print('Doc converted to Task...');
                      },
                      title: Text(doc['username']),
                      subtitle: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('task').where('assignedto', isEqualTo: doc['userid']).snapshots(),
                        builder: (context, snapshot){
                          int numTasks = 0;
                          if(!snapshot.hasData || snapshot.data.docs.length == 0){
                            numTasks = 0;
                            return Text('No tasks assigned yet');
                          }
                          else{
                            numTasks = snapshot.data.docs.length;
                            return Text('Assigned Tasks: '+numTasks.toString());
                          }

                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          if(doc['username'] == 'Unassigned') {
                            print('++++++++++++++++++++++++++++++++++++++++++++++++++');
                            print('Cannot delete Unassigned user');
                            print('++++++++++++++++++++++++++++++++++++++++++++++++++');
                          }
                          else{
                            doc.reference.delete();
                          }
                        },
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }

  Widget getsubtitle(String userid) {
    print('Incoming userid:'+userid);
    StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('task').where('assignedto', isEqualTo: userid).snapshots(),
      builder: (context, snapshot){
        int numTasks = 0;
        if(!snapshot.hasData){
          numTasks = 0;
      }
      else{
          numTasks = snapshot.data.docs.length;
        }
      return Text('Assigned Tasks: '+numTasks.toString());
    },
    );
  }

}


