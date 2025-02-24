import 'package:caterbuddy/pages/login_page.dart';
import 'package:caterbuddy/pages/signup_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CaterBuddy Home"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        fit: StackFit.expand, // Ensures full-screen coverage
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/home_bg.jpg"), // Make sure this exists
                fit: BoxFit.cover, // Ensures the image covers the whole screen
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome to CaterBuddy!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 5, color: Colors.black54, offset: Offset(2, 2))
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    // Navigate to Login Page
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));

                  },
                  child: Text("Login"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));

                  },
                  child: Text("Signup"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

