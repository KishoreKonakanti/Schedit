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

  List<DropdownMenuItem> getUsers(){
    populateUsers();
    print('Populated users');
    print(this._userlist.toString());
    return this._userlist;
  }

  Future<void> populateUsers() async {
    // items.add(DropdownMenuItem( child: Text('Rajesh'), value: 'raj', ));
    // items.add(DropdownMenuItem( child: Text('Krishna'), value: 'kp', ));

    print('Fetching user list');

    QuerySnapshot qysn = await dbinstance.collection('users').get();
    qysn.docs.forEach((element) {
      this._userlist.add(DropdownMenuItem(child: Text(element['username'].toString()),
          value: element['userid'].toString()));
    });

    // await dbinstance.collection("users").get().then((querySnapshot)
    // {
    //   // userlist.addEntries(querySnapshot.docs.asMap());
    //     querySnapshot.docs.forEach((doc) {
    //       print(doc.data());
    //       userlist[doc['userid'].toString()] = doc['username'].toString();
    //     });
    // });

    print('Populated users as:' + this._userlist.toString());
    assert(this._userlist.length != 0, 'Couldnt get user names');
  }
}


