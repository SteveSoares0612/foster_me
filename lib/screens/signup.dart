import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  static const routeName = '/signup';
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Widget buildText(String text, icon) {
    return Container(
      width: 330,
      height: 70,
      decoration: BoxDecoration(),
      child: TextField(
        decoration: InputDecoration(
          suffixIcon: Icon(
            icon,
            size: 15,
          ),
          labelText: text,
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromRGBO(255, 231, 277, 1),
              Color.fromRGBO(255, 0, 0, 1)
            ])),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 150,
                ),
                Container(
                  width: 400,
                  height: 630,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Welcome!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Register your credentials to Sign up!",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      buildText("Username", FontAwesomeIcons.user),
                      SizedBox(
                        height: 2,
                      ),
                      buildText("Name", FontAwesomeIcons.addressBook),
                      SizedBox(
                        height: 2,
                      ),
                      buildText("Email", FontAwesomeIcons.envelope),
                      SizedBox(
                        height: 2,
                      ),
                      buildText("Password", FontAwesomeIcons.eyeSlash),
                      SizedBox(
                        height: 2,
                      ),
                      buildText("Confirm Password", FontAwesomeIcons.eyeSlash),
                      ElevatedButton(
                          onPressed: () => print("Hello"),
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(330, 50),
                              primary: Colors.deepOrange),
                          child: Text("Sign Up")),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () => {
                                      Navigator.of(context)
                                          .popAndPushNamed(Login.routeName)
                                    },
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                      color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
