import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_notes/Screens/Admin/admin_screen.dart';
import 'package:flutter_book_notes/Screens/BookList/personal_book_screen.dart';
import 'package:flutter_book_notes/Screens/Login/login_screen.dart';
import 'package:flutter_book_notes/components/rounded_button.dart';
import 'package:flutter_book_notes/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookNoteAdd extends StatefulWidget {
  BookNoteAdd({this.username, this.book_id, this.books_name, this.book_author, this.email});
  final String username, book_id,books_name, book_author,email;
  @override
  State<StatefulWidget> createState() { return new BookNoteAddState();}
}

class BookNoteAddState extends State<BookNoteAdd>{
  @override
  String usernamee = "";

  Future getUsername()async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      usernamee = preferences.getString('username');
    });
  }

  TextEditingController note = TextEditingController();

  addBookNote() async{
    var url = "http://192.168.1.36/flutter_book_notes/addorUpdate.php";
    var response = await http.post(url, headers: {"ContentType": "application/json"}, body: {
      "username" : widget.username,
      "book_id": widget.book_id,
      "books_note": note.text,
    });

    var data = json.decode(response.body.toString());

    if(data == "Success1"){
      Fluttertoast.showToast(
        msg: "Note is updated.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.lightGreen,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    else {
      Fluttertoast.showToast(
        msg: "Note is added.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.lightGreen,
        textColor: Colors.white,
        fontSize: 16.0,

      );
    }

  }
  Map<String, dynamic> bookNotes;
  getBookNote() async{
    var url = "http://192.168.1.36/flutter_book_notes/getBookNotes.php";
    var response = await http.post(url, headers: {"ContentType": "application/json"}, body: {
      "username" : widget.username,
      "book_id": widget.book_id,
    });
    if(response.statusCode == 200){
      setState(() {
        bookNotes = json.decode(response.body);
      });
      if(bookNotes["books_note"]!=null){
        note.text = bookNotes["books_note"];
      }
      return bookNotes;
    }
  }
  @override
  void initState(){
    super.initState();
    getBookNote();

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
              title: new Text("Book Note Add Screen", style: new TextStyle(fontSize: 15.0),),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminScreen(username: widget.username)));
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
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => BookList(username: widget.username)));
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
            body: Container(
                child: Column(
                  children: [
                    TextField(
                      controller: note,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        hintText: "Add note",
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      maxLines: 5,

                    ),
                    RoundedButton(
                      text: "Add or Update",
                      press: () {
                        addBookNote();
                      },
                    ),
                  ],
                ),
              padding: EdgeInsets.all(32),

            ),

          ),
        ],
      ),
    );
  }
}
