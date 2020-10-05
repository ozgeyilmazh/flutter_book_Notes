import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_book_notes/Screens/Admin/admin_screen.dart';
import 'package:flutter_book_notes/Screens/Admin/settings.dart';
import 'package:flutter_book_notes/Screens/BookList/book_note_add_screen.dart';
import 'file:///C:/xampp/htdocs/flutter_book_notes/lib/Screens/Member/settings.dart';
import 'package:flutter_book_notes/Screens/Login/login_screen.dart';
import 'package:flutter_book_notes/Screens/Member/member_screen.dart';
import 'package:flutter_book_notes/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookList extends StatefulWidget {
  BookList({this.username, this.level,this.email});
  final String username,level,email;
  @override
  State<StatefulWidget> createState() { return new BookListState();}
}

class BookListState extends State<BookList>{
  @override
  String usernamee = "";

  Future getUsername()async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      usernamee = preferences.getString('username');
    });
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


  String book_id,books_name,author,user,note;
  List bookList = List();
  List bookList_display = List();

  getBookList() async{
    var url = "http://192.168.1.36/flutter_book_notes/getPersonalBookList.php";
    var response = await http.post(url, headers: {"ContentType": "application/json"}, body: {
        "username" : widget.username,
    });
    if(response.statusCode == 200){
      setState(() {
        bookList = json.decode(response.body);
        bookList_display = bookList;
      });

      return bookList_display;
    }
  }
  Map<String, dynamic> bookNotes;
  getBookNote(id) async{

    var url = "http://192.168.1.36/flutter_book_notes/getBookNotes.php";
    var response = await http.post(url, headers: {"ContentType": "application/json"}, body: {
      "username" : widget.username,
      "book_id": id,
    });

    if(response.statusCode == 200){
      setState(() {
        bookNotes = json.decode(response.body);
        Widget okButton = FlatButton(
          child: Text("OK"),
          onPressed: () { Navigator.of(context).pop(); },
        );

        if(bookNotes!=null){
          note = bookNotes["books_note"];
          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: Text("My note"),
            content: Text(note),
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
        else{
          note = "No note added yet";
          AlertDialog alert = AlertDialog(
            title: Text("My note"),
            content: Text(note),
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
      });
      return note;
    }
  }

  @override
  void initState(){
    super.initState();
    getBookList();
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
              title: new Text("MyBookList: " + widget.level + " " + widget.username, style: new TextStyle(fontSize: 15.0),),
              backgroundColor: kPrimaryColor,
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(widget.username, style: new TextStyle(color: kPrimaryColor), ),
                    accountEmail: Text(widget.email, style: new TextStyle(color: kPrimaryColor),),
                    decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                    ),
                  ),
                  ListTile(
                    title: Text("General Book List"),
                    trailing: Icon(Icons.book,color: kPrimaryColor,),
                    onTap: () {
                      if(widget.level == "admin"){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminScreen(username: widget.username)));
                      }
                      else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MemberScreen(username: widget.username)));
                      }
                    },
                  ),
                  ListTile(
                    title: Text("My Book List"),
                    trailing: Icon(Icons.collections_bookmark, color: kPrimaryColor,),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BookList(username: widget.username, email: widget.email,)));
                    },
                  ),
                  ListTile(
                    title: Text("Settings"),
                    trailing: Icon(Icons.settings, color: kPrimaryColor,),
                    onTap: () {
                      if(widget.level == "member")
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MemberSettings(username: widget.username, level: widget.level, email: widget.email,)));
                      else
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminSettings(username: widget.username, level: widget.level, email: widget.email,)));

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
      trailing: IconButton(
        icon: new Icon(Icons.note_add , color: kPrimaryColor,),
        onPressed: () {
          book_id = bookList_display[index]["book_id"];
          books_name = bookList_display[index]["books_name"];
          author = bookList_display[index]["author"];
          user = widget.username;
          Navigator.push(context, MaterialPageRoute(builder: (context) => BookNoteAdd(username: widget.username, book_id: book_id, books_name: books_name, book_author: author, email: widget.email,)));
        },
      ),
      onTap: () {
        book_id =bookList_display[index]["book_id"];
        getBookNote(book_id);
        // set up the button

      },
    );
  }
}
