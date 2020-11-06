import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class users
{
  users(){
    //To-do
    print("asd");
  }
  String idtoName({String userid}) {
    //print("Ignited");
    DocumentSnapshot docs = FirebaseFirestore.instance.collection('users')
        .where('userid', isEqualTo: userid)
        .snapshots()
    as DocumentSnapshot;

    print(docs["username"]);
    return docs["username"];
  }

  getUserList() {
    print("asd");
    return null;
  }
}

var usrs = new users();
usrs.idtoName("aj");


