import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foster_me/screens/cms.dart';
import 'package:foster_me/screens/menuFrame.dart';
import '../models/authentication.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/petOptions.dart';
import '../widgets/petView.dart';
import '../models/animals.dart';
import 'package:provider/provider.dart';
import '../models/authentication.dart';

// @override
// void initState() {
//   log("${Auth().}", name: "Logged in?");
// }

class MenuOption extends StatefulWidget with ChangeNotifier {
  @override
  State<MenuOption> createState() => _MenuOptionState();
}

class _MenuOptionState extends State<MenuOption> {
  List<IconData> icons = [
    FontAwesomeIcons.paw,
    FontAwesomeIcons.userAlt,
  ];

  List<String> menuItems = [
    'Our Pets',
    'Profile',
  ];

  int selectedMenuIndex = 0;

  Widget buildMenuRow(int index) {
    return InkWell(
      onTap: () {
        // setState(() {
        //   selectedMenuIndex = index;
        //   widget.menuCallback(index);
        // });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Row(
          children: <Widget>[
            Icon(
              icons[index],
              size: 17.0,
              color: selectedMenuIndex == index
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
            ),
            SizedBox(
              width: 16.0,
            ),
            Text(
              menuItems[index],
              style: TextStyle(
                color: selectedMenuIndex == index
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openCMS(BuildContext context) {
    Navigator.of(context).pushNamed(CMS.routeName);
  }

  @override
  Widget build(BuildContext context) {
    bool isAuthenticated = Provider.of<Auth>(context, listen: false).auth;
    String LoggedInUser =
        Provider.of<Auth>(context, listen: false).loggedInUser;
    bool isAdmin = Provider.of<Auth>(context, listen: true).isAdmin;

    return Container(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: Provider.of<Auth>(context,
                                          listen: false)
                                      .users[0]
                                      .profileImage !=
                                  ''
                              ? NetworkImage(
                                  "${Provider.of<Auth>(context, listen: false).users[0].profileImage}")
                              : AssetImage("assets/Images/user.png"),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Provider.of<Auth>(context, listen: false)
                                    .users[0]
                                    .fullName !=
                                ''
                            ? Text(
                                "${Provider.of<Auth>(context, listen: false).users[0].fullName}",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              )
                            : Text(
                                "Username",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                        Row(
                          children: [
                            isAdmin
                                ? Text(
                                    "Admin",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  )
                                : Text(
                                    "Fosterer",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.paw,
                            size: 17.0,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Text(
                            "Our Pets",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.userAlt,
                          size: 17.0,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  isAdmin
                      ? Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.plus,
                                size: 17.0,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              InkWell(
                                onTap: () {
                                  openCMS(context);
                                },
                                child: Container(
                                  width: 180,
                                  child: Flexible(
                                    child: Text(
                                      "Add Pet",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      size: 17.0,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<Auth>(context, listen: false).logout();
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
