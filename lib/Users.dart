
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class users
{
  CollectionReference userCollections = FirebaseFirestore.instance.collection('users');
  users(){
    //To-do
    print("asd");
  }

  String idtoName(String userid)
  {
    print("Ignited");
    try {
      userCollections.snapshots();
      DocumentSnapshot docs = userCollections.where('userid', isEqualTo: userid)
          .snapshots() as DocumentSnapshot;

      Stream<QuerySnapshot> streamBuilder = userCollections.snapshots();

      Stream<QuerySnapshot> qy =  FirebaseFirestore.instance.collection("task").snapshots();

      if (qy.isEmpty == true)
      {

      }
      else
      {
        qy.forEach((element) {
          List<QueryDocumentSnapshot> docs = element.docs;
          if(docs.isNotEmpty){
            print(docs.toString());
          }

        })
        print('# of documents:'+qy.data.documents.length);
        for(int i = 0 ;i < qy.data.documents.length; i++)
        {
          DocumentSnapshot doc = qy.data.documents[i];
            print('Task Name:'+doc['taskname']);
        }
      print(docs["username"]);
      return docs["username"];
    }
    catch(e){
      print('Exception raised:'+e.toString());
    }

  }
//
//   getUserList()
//   {
//     print("Returns user list with usernames and ids");
//     DocumentSnapshot docs = FirebaseFirestore.instance.collection('users').snapshots() as DocumentSnapshot;
//     // db.collection("sports").get()
//     //     .addOnCompleteListener(new OnCompleteListener<QuerySnapshot>() {
//     // @Override
//     // public void onComplete(@NonNull Task<QuerySnapshot> task) {
//     // if (task.isSuccessful()) {
//     // for (QueryDocumentSnapshot document : task.getResult()){
//     // spinnerDataList.add(document.getString("Description"));
//     // }
//     // adapter.notifyDataSetChanged();
//     // }
//     // }
//     // });
//   }
// }

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  print('Initialized App');
  var usrs = new users();
  usrs.idtoName("aj");
}

