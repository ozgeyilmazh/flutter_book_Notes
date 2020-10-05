import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_book_notes/Screens/Admin/admin_screen.dart';
import 'package:flutter_book_notes/Screens/BookList/personal_book_screen.dart';
import 'package:flutter_book_notes/Screens/Login/login_screen.dart';
import 'package:flutter_book_notes/Screens/Member/member_screen.dart';
import 'package:flutter_book_notes/Screens/SignUp/components/or_divider.dart';
import 'package:flutter_book_notes/components/rounded_button.dart';
import 'package:flutter_book_notes/components/rounded_input_field.dart';
import 'package:flutter_book_notes/components/rounded_password_field.dart';
import 'package:flutter_book_notes/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminSettings extends StatefulWidget {
  AdminSettings({this.username, this.level,this.email});
  final String username,level,email;
  @override
  State<StatefulWidget> createState() { return new AdminSettingsState();}
}

class AdminSettingsState extends State<AdminSettings>{
  @override



  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();


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

  List UserDatas = List();
  getUser() async{
    var url = "http://192.168.1.36/flutter_book_notes/getUserData.php";
    var response = await http.post(url, headers: {"ContentType": "application/json"}, body: {
      "username" : widget.username,
    });
    if(response.statusCode == 200){
      setState(() {
        UserDatas = json.decode(response.body);
        name.text = UserDatas[0]["name"];
        email.text = UserDatas[0]["email"];
        user.text = UserDatas[0]["username"];
        pass.text = UserDatas[0]["password"];

      });

      return UserDatas;
    }
  }

  @override
  void initState(){
    super.initState();
    getUser();
  }

  updateUserDatas() async{
    var url = "http://192.168.1.36/flutter_book_notes/updateUserData.php";
    var response = await http.post(url, headers: {"ContentType": "application/json"}, body: {
      "name" : name.text,
      "email" : email.text,
      "username" : widget.username,
      "password": pass.text,
    });

    var data = json.decode(response.body.toString());
    print(data);
    if(data == "Success"){
      Fluttertoast.showToast(
        msg: "User is updated.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.lightGreen,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      if(widget.username != user.text){
        Fluttertoast.showToast(
          msg: "Username cannot change.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
    else {
      Fluttertoast.showToast(
        msg: "Couldn't done.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.lightGreen,
        textColor: Colors.white,
        fontSize: 16.0,

      );
    }
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
              title: new Text("MyBookList: " + widget.username, style: new TextStyle(fontSize: 15.0),),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BookList(username: widget.username, level: widget.level, email: widget.email,)));
                    },
                  ),
                  ListTile(
                    title: Text("Settings"),
                    trailing: Icon(Icons.settings, color: kPrimaryColor,),
                    onTap: () {
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
            Container(
              margin: EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.level , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: kPrimaryColor, backgroundColor: kPrimaryLightColor,),),
                    RoundedInputField(
                      controller: name,
                      hintText: "Name Surname",
                    ),
                    RoundedInputField(
                      controller: email,
                      hintText: "Email",
                    ),
                    RoundedInputField(
                      controller: user,
                      hintText: "Username",
                    ),
                    RoundedInputField(
                      controller: pass,
                      icon: Icons.lock,
                      hintText: "Password",
                    ),
                    RoundedButton(
                      text: "Update Informations",
                      press: (){
                        updateUserDatas();
                      },
                    ),
                    OrDivider(),
                    //RoundedButton(
                    //  text: "Accept admin requests",
                    //  press: (){
                    //  },
                    //),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
