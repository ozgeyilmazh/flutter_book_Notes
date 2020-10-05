
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_book_notes/Screens/Admin/admin_screen.dart';
import 'package:flutter_book_notes/Screens/Member/member_screen.dart';
import 'package:flutter_book_notes/Screens/SignUp/signup_screen.dart';
import 'package:flutter_book_notes/Screens/Welcome/components/background.dart';
import 'package:flutter_book_notes/components/already_have_an_account_acheck.dart';
import 'package:flutter_book_notes/components/rounded_button.dart';
import 'package:flutter_book_notes/components/rounded_input_field.dart';
import 'package:flutter_book_notes/components/rounded_password_field.dart';
import 'package:flutter_book_notes/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var username = preferences.getString('username');
  runApp(MaterialApp(home: username == null ? LoginScreen() : AdminScreen(username: username),));
}


class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body>{
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future login() async{
    var url = "http://192.168.1.36/flutter_book_notes/login.php";
    var response = await http.post(url, headers: {"ContentType": "application/json"}, body: {
      "username" : user.text,
      "password" : pass.text,
    });

    var data = json.decode(response.body.toString());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('username', user.text);
    if(data == "Success1"){
      Fluttertoast.showToast(
        msg: "Admin-Login Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.lightGreen,
        textColor: kPrimaryColor,
        fontSize: 16.0,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminScreen(username: user.text,)));

    }
    else if(data == "Success2"){
      Fluttertoast.showToast(
        msg: "Member-Login Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.lightGreen,
        textColor: kPrimaryColor,
        fontSize: 16.0,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => MemberScreen(username: user.text,)));
    }
    else {

      Fluttertoast.showToast(
        msg: "Username or password is wrong. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryLightColor,
        textColor: kPrimaryColor,
        fontSize: 16.0,

      );

    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              controller: user,
              hintText: "Username",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              controller: pass,
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                login();
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
