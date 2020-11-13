import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scheduler/Task.dart';
import 'Task.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: chatwidget(null)));
}

class chat{
  String _taskid;
  String _chatid;
  String _userid;
  String _chattext;
  DateTime _chattime;
  String username;
  chat(this._taskid,this._chatid, this._userid, this._chattext, this._chattime){
    // Map userid to username
    this.username = 'ToDo';
  }

}

class chatwidget extends StatefulWidget{
  String _taskid = '768821930';
  chatwidget(this._taskid);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return chatwidgetwindow(this._taskid);
  }
}

class chatwidgetwindow extends State<chatwidget>{
  String _taskid;
  List<String> chats = ['Hello','Hi','Bye'];
  List<String> userids = ['7330606444','7995004620','9490315020'];
  chatwidgetwindow(this._taskid);
  TextEditingController sendmessagectrl = new TextEditingController();

  Widget message(String message){
    return Column(
      children: <Widget>[
                Container(
                alignment: Alignment.topRight,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.80,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )),
        ]
    );
  }

  Widget chattolisttile(String chattext, String username, String chattime){
    return Row(

      children: [
        Text(username+': ',textAlign: TextAlign.left,),
        Text(chattext),
        Text(chattime, textAlign: TextAlign.right,)
      ],
    );
  }

  Widget sendMessage(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: sendmessagectrl,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message..',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {
                String text = sendmessagectrl.text;
                commitMessage(text);
                setState(() {
                  chats.add(text);
                  sendmessagectrl.text = '';
                });
            },
          ),
        ],
      ),
    );
  }

  void commitMessage(String message) async{
    await Firestore.instance.collection('chats').add(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BackButton(
        onPressed: null,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(text:'Task Name',style:TextStyle(fontSize: 20.0)),
              TextSpan(text:'\n'),
              TextSpan(text: 'Task desc', style:TextStyle(fontSize: 15.0))
            ]
          ),
        )
      ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
      children: [

          Expanded(

            child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index){
              String chattext = chats[index];
              String username = 'Raj';
              String chattime = '10-Nov 11:00 AM';
              String msg = 'Raj: '+chattext;
              return message(msg);
            }
            ),

          ),
        sendMessage()

      ],
          ),
        ));
  }

}