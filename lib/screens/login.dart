import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foster_me/models/authentication.dart';
import 'package:foster_me/models/httpException.dart';
import 'package:foster_me/screens/signup.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class Login extends StatefulWidget {
  static const routeName = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  var _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String error_message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occured!'),
              content: Text(error_message),
              actions: [
                FloatingActionButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).loginUser(
          _authData['email'],
          _authData['password'],
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signUpUser(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HTTPException catch (error) {
      var message = "Authentication failed";
      if (error.toString().contains("EMAIL_EXISTS")) {
        message = "Email is already in use.";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        message = "Email address is not valid";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        message = "Password is too weak.";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        message = "Invalid Email.";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        message = "Invalid Password";
      }
      _showErrorDialog(message);
    } catch (error) {
      var message = "Could not authenticate. Please try again later.";
      _showErrorDialog(message);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

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
              Color.fromRGBO(48, 96, 53, 1.0),
              Color.fromRGBO(40, 123, 33, 1.0),
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
            ),
            Container(
              width: 300,
              height: _authMode == AuthMode.Login ? 470 : 500,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  _authMode == AuthMode.Login
                      ? Text(
                          "Hello",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        )
                      : Text(
                          "Welcome!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  _authMode == AuthMode.Login
                      ? Center(
                          child: Text(
                            "Enter your username and password to login!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 13),
                          ),
                        )
                      : Text(
                          "Register your credentials to Sign up!",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 270,
                            height: 70,
                            child: TextFormField(
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  FontAwesomeIcons.envelope,
                                  size: 15,
                                ),
                                labelText: "Email Address",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value != null) {
                                  if (value.isEmpty || !value.contains('@')) {
                                    return 'Invalid Email';
                                  }
                                  return null;
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                _authData['email'] = value;
                              },
                            ),
                          ),
                          Container(
                            width: 270,
                            height: 70,
                            child: TextFormField(
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  FontAwesomeIcons.eyeSlash,
                                  size: 15,
                                ),
                                labelText: "Password",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                              obscureText: true,
                              controller: _passwordController,
                              validator: (value) {
                                if (value != null) {
                                  if (value.isEmpty || value.length < 5) {
                                    return 'Password is too short!';
                                  }
                                }
                              },
                              onSaved: (value) {
                                _authData['password'] = value;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (_authMode == AuthMode.Signup)
                    Container(
                      width: 270,
                      height: 70,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            FontAwesomeIcons.eyeSlash,
                            size: 15,
                          ),
                          labelText: "Confirm Password",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  print('Password do not Match!');
                                }
                              }
                            : null,
                      ),
                    ),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    Container(
                      width: 250,
                      child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(330, 50),
                              primary: Theme.of(context).primaryColor),
                          child: _authMode == AuthMode.Login
                              ? Text("Login")
                              : Text("Sign Up")),
                    ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    width: 250,
                    // decoration: BoxDecoration(color: Colors.black),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: null,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 12),
                          ),
                        ),
                        TextButton(
                          onPressed: switchAuthMode,
                          child: _authMode == AuthMode.Login
                              ? Text(
                                  "Don't have an account? Sign Up",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor),
                                )
                              : Text(
                                  "Already have an account? Log In",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor),
                                ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
