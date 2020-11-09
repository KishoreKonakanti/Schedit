import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class Users {
  CollectionReference userCollections = FirebaseFirestore.instance.collection(
      'users');
  final dbinstance = FirebaseFirestore.instance;
  final List<DropdownMenuItem> _userlist = [];

  Users() {
    //To-do
    print("In Users constructor");
    // this.getUsers();
  }


  List<DropdownMenuItem> getUsers() {
    populateUsers();
    print('Populated users');
    print(this._userlist.toString());
    return this._userlist;
  }

  populateUsers() {
    print('*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=');
    print('Retrieving users...');
    bool gotdata = false;

    dbinstance.collection("users").get(GetOptions(source: Source.cache)).then((
        querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.data());
        gotdata = true;
        // userlist[doc['userid'].toString()] = doc['username'].toString();
      });
    });

    print('*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=');
  }
}



