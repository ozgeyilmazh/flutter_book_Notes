
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_notes/Screens/Login/login_screen.dart';
import 'package:flutter_book_notes/Screens/SignUp/components/social_icon.dart';
import 'package:flutter_book_notes/components/already_have_an_account_acheck.dart';
import 'package:flutter_book_notes/components/rounded_button.dart';
import 'package:flutter_book_notes/components/rounded_input_field.dart';
import 'package:flutter_book_notes/components/rounded_password_field.dart';
import 'package:flutter_book_notes/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'background.dart';
import 'or_divider.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body>{

  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  Future register()async{
    var url = "http://192.168.1.36/flutter_book_notes/register.php";
    var response = await http.post(url, headers: {"ContentType": "application/json"}, body: {
      "username" : user.text,
      "password" : pass.text,
      "email" : email.text,
      "name" : name.text,
    });
    print(response.body.toString());
    print(user.text.toString() + "-" + pass.text.toString());
    var data = json.decode(response.body.toString());

    if(data == "Error"){
      Fluttertoast.showToast(
          msg: "This User Already Exist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightGreen,
          textColor: kPrimaryColor,
          fontSize: 16.0,
      );
    }
    else {

      Fluttertoast.showToast(
        msg: "Registration Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryLightColor,
        textColor: kPrimaryColor,
        fontSize: 16.0,

      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
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
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.00001),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.15,
            ),
            RoundedInputField(
              controller: name ,
              hintText: "Name Surname",
            ),
            RoundedInputField(
              controller: email,
              hintText: "Email",
            ),
            RoundedInputField(
              onChanged: (value) {},
              controller: user,
              hintText: "Username",
            ),
            RoundedPasswordField(
              controller: pass,
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {
                register();
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),

          ],
        ),
      ),
    );
  }
}
