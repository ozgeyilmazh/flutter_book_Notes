import 'dart:convert';

import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_notes/Screens/Admin/admin_screen.dart';
import 'package:flutter_book_notes/Screens/BookList/personal_book_screen.dart';
import 'package:flutter_book_notes/Screens/Login/login_screen.dart';
import 'package:flutter_book_notes/components/rounded_button.dart';
import 'package:flutter_book_notes/components/rounded_input_field.dart';
import 'package:flutter_book_notes/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminAddBookScreen extends StatefulWidget {
  AdminAddBookScreen({this.username, this.book_id, this.books_name, this.book_author, this.email});
  final String username, book_id,books_name, book_author, email;
  @override
  State<StatefulWidget> createState() { return new AdminAddBookScreentate();}
}

class AdminAddBookScreentate extends State<AdminAddBookScreen>{
  @override
  String usernamee = "";

  Future getUsername()async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      usernamee = preferences.getString('username');
    });
  }
  String selectedName;
  List authorList = List();
  TextEditingController author = TextEditingController();
  TextEditingController books_name = TextEditingController();

  addBook() async{
    var url = "http://192.168.1.36/flutter_book_notes/addBook.php";
    var response = await http.post(url, headers: {"ContentType": "application/json"}, body: {
      "author" : author.text,
      "books_name" : books_name.text,
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
        content: Text("This Book Already Added"),
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
        msg: "Books is added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryLightColor,
        textColor: kPrimaryColor,
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
              title: new Text("Book Add Screen", style: new TextStyle(fontSize: 15.0),),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BookList(username: widget.username)));
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
                  RoundedInputField(
                    hintText: "Author",
                    controller: author,
                  ),
                  RoundedInputField(
                    controller: books_name,
                    hintText: "Book's Name",
                    maxLines: 2,
                    icon: Icons.library_books,
                  ),

                  RoundedButton(
                    text: "Add",
                    press: () {
                      addBook();
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
