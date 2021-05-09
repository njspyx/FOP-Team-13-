import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fop_team_13/screens/login.dart';
import 'package:fop_team_13/screens/signup.dart';
import 'package:fop_team_13/widgets/round_button.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "WELCOME",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(height: size.height * 0.5),
          RoundedButton(
            text: "LOG IN",
            onpress: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }));
            },
          ),
          RoundedButton(
            text: "SIGN UP",
            onpress: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return SignupScreen();
              }));
            },
          ),
        ],
      ),
    );
  }
}
