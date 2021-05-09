import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fop_team_13/screens/home.dart';
import 'package:fop_team_13/widgets/round_button.dart';
import 'package:fop_team_13/widgets/round_text_input.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "SIGNUP",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(height: size.height * 0.3),
          RoundTextInput(
              child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.account_circle),
                hintText: "Username"),
          )),
          RoundTextInput(
              child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.lock),
                hintText: "Password",
                suffixIcon: Icon(Icons.visibility)),
          )),
          RoundedButton(
              text: "SIGN UP",
              onpress: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return MyHomePage(title: 'Sprint 4 Demo');
                }));
              })
        ],
      ),
    );
  }
}
