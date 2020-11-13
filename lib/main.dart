import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/screens/chatscreen.dart';
import 'screens/listtasks.dart';
import 'screens/createTask.dart';
import 'screens/usermgmt.dart';
import 'screens/edittask.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(home: listtasks(null),
      title: 'Scheduler_TL',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
  initialRoute: '/',
  routes:<String, WidgetBuilder>{
    '/home': (context) => listtasks(null),
    '/createtask': (context) => createTaskForm(),
    '/edittask': (context) => edittask(),
    '/users': (context) => usermgmt(),
    '/chats': (context) => chatwidget()
  }));
}

