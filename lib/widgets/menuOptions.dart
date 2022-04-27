import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foster_me/screens/cms.dart';
import 'package:foster_me/screens/menuFrame.dart';
import 'package:foster_me/screens/menu_screen.dart';
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
  int selectedMenuIndex = 0;
  List<IconData> icons = [
    FontAwesomeIcons.paw,
    FontAwesomeIcons.userAlt,
  ];

  List<String> menuItems = [
    'Our Pets',
    'Profile',
  ];

  void openCMS(BuildContext context) {
    Navigator.of(context).pushNamed(CMS.routeName);
  }

  @override
  Widget build(BuildContext context) {
    bool isAuthenticated = Provider.of<Auth>(context, listen: false).auth;
    String LoggedInUser =
        Provider.of<Auth>(context, listen: false).loggedInUser;
    bool isAdmin = Provider.of<Auth>(context, listen: true).isAdmin;

    return null;
  }
}
