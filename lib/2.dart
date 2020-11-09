import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  Firebase.initializeApp();
  StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection("users").snapshots(),
    builder: (context, snapshot) {
      print(snapshot.data);
    },
  );
}