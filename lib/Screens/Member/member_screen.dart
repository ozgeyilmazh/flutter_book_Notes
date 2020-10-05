import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_book_notes/Screens/BookList/personal_book_screen.dart';
import 'file:///C:/xampp/htdocs/flutter_book_notes/lib/Screens/Member/settings.dart';
import 'package:flutter_book_notes/Screens/Login/login_screen.dart';
import 'package:flutter_book_notes/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MemberScreen extends StatefulWidget {
  MemberScreen({this.username});
  final String username;
  @override
  State<StatefulWidget> createState() { return new MemberScreenState();}
}

class MemberScreenState extends State<MemberScreen>{
  @override
  String usernamee = "";

  Future getUsername()async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      usernamee = preferences.getString('username');
    });
  }
  String book_id,books_name,author,user;

  List bookList = List();
  List bookList_display = List();


  getBookList() async{
    var response = await http.get("http://192.168.1.36/flutter_book_notes/getBookList.php");
    if(response.statusCode == 200){
      setState(() {
        bookList = json.decode(response.body);
        bookList_display = bookList;
      });

      return bookList_display;
    }
  }
  List emailList = List();
  getEmail() async{
    var url = "http://192.168.1.36/flutter_book_notes/getEmail.php";
    var response = await http.post(url, headers: {"ContentType": "application/json"}, body: {
      "username" : widget.username,
    });
    if(response.statusCode == 200){
      setState(() {
        emailList = json.decode(response.body);
      });

      return emailList;
    }
  }

  @override
  void initState(){
    getBookList();
    getEmail();
    super.initState();
  }

  addPersonalBookList(bookId, bookName, bookAuthor) async{

    var url = "http://192.168.1.36/flutter_book_notes/addUserBookList.php";
    var response = await http.post(url, headers: {"ContentType": "application/json"}, body: {
      "username" : widget.username,
      "book_id" : bookId,
      "books_name" : bookName,
      "author" : bookAuthor,
    });
    var data = json.decode(response.body.toString());
    if(data == "Error"){
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () { Navigator.of(context).pop(); },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Alert"),
        content: Text("You added your list before."),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    else {
      Fluttertoast.showToast(
        msg: "Successful. Added the list.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.lightGreen,
        textColor: Colors.white,
        fontSize: 16.0,
      );

    }

  }

  Future logOut(BuildContext context)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('username');
    Fluttertoast.showToast(
        msg: "Logout Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.amber,
        textColor: Colors.white,
        fontSize: 16.0
    );
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen(),),);
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[

          Scaffold(
            appBar: AppBar(
              title: new Text("Welcome Member: "+widget.username, style: new TextStyle(fontSize: 15.0),),
              backgroundColor: kPrimaryColor,
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(widget.username, style: new TextStyle(color: kPrimaryColor), ),
                    accountEmail: Text(emailList[0]['email'], style: new TextStyle(color: kPrimaryColor),),
                    decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                    ),
                  ),
                  ListTile(
                    title: Text("General Book List"),
                    trailing: Icon(Icons.book,color: kPrimaryColor,),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MemberScreen(username: widget.username)));
                    },
                  ),
                  ListTile(
                    title: Text("My Book List"),
                    trailing: Icon(Icons.collections_bookmark, color: kPrimaryColor,),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BookList(username: widget.username, level: "member", email: emailList[0]['email'],)));
                    },
                  ),
                  ListTile(
                    title: Text("Settings"),
                    trailing: Icon(Icons.settings, color: kPrimaryColor,),
                    onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MemberSettings(username: widget.username, level: "member", email: emailList[0]['email'],)));
                    },
                  ),

                  Divider(
                    height: 10.0,
                    color: kPrimaryColor,
                  ),
                  ListTile(
                    title: Text("Logout"),
                    leading: Icon(Icons.close, color: Colors.black,),
                    onTap: (){
                      logOut(context);
                    },
                  )
                ],
              ),
            ),

            body:
            ListView.builder(
              itemBuilder: (context, index){
                return index == 0 ? _searchBar() : _listItem(index-1);
              },
              itemCount: bookList_display.length+1,
            ),
          ),
        ],
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          icon:new Icon(Icons.search),
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            bookList_display = bookList.where((book){
              var books = book["books_name"].toLowerCase();
              return books.contains(text);
            }).toList();
          });

        },
      ),
    );
  }
  _listItem(index) {

    return ListTile(
      title: Text(bookList_display[index]["books_name"],),
      subtitle: Text(bookList_display[index]["author"]),
      trailing: RaisedButton(
        child: new Icon(Icons.check, color: Colors.green,),
        onPressed: () {
          book_id = bookList_display[index]["id"];
          books_name = bookList_display[index]["books_name"];
          author = bookList_display[index]["author"];

          addPersonalBookList(book_id, books_name,author);
        },
      ),
    );
  }
}
