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
