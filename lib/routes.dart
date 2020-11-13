import 'package:flutter/material.dart';
import 'package:scheduler/TaskListing.dart';
import 'Task.dart';
import 'constants.dart';
import 'edittask.dart';
import 'createTask.dart';
import 'displaytaskdetails.dart';
import 'usermgmt.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
     Route<dynamic> generateRoute(RouteSettings settings) {
      switch (settings.name) {
        case homeroute:
          var filters = settings.arguments as String;
          return MaterialPageRoute(builder: (_) => TaskListing(filters));
        case tasklistroute:
          var filters = settings.arguments as String;
          return MaterialPageRoute(builder: (_) => TaskListing(filters));
        case taskcreateroute:
          return MaterialPageRoute(builder: (_) => createTaskForm());
        case taskdisproute:
          var task = settings.arguments as Task;
          return MaterialPageRoute(builder: (_) => displaytaskdetails(task));
        case taskeditroute:
          var task = settings.arguments as Task;
          return MaterialPageRoute(builder: (_) => edittask(task: task));
        case userlistroute:
          return MaterialPageRoute(builder: (_) => usermgmt());
        default:
          return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
      }
    }
  }
}