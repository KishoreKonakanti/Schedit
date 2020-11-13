import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scheduler/TaskListing.dart';
import 'package:scheduler/edittask.dart';
import 'package:scheduler/screens/displaytaskdetails.dart';
import 'package:scheduler/Task.dart';
import 'package:scheduler/usermgmt.dart';
import 'createTask.dart';
import 'package:get/get.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: TaskListingState(null),
      title: 'Scheduler_TL',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
  initialRoute: '/',
  routes:<String, WidgetBuilder>{
    '/home': (context) => TaskListingState(null),
    '/createtask': (context) => createTaskForm(),
    '/edittask': (context) => edittask(),
    '/users': (context) => usermgmt(),
  }));
}

