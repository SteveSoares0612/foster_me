import 'package:flutter/material.dart';
import '../widgets/menuOptions.dart';

Color firstColor = Color.fromRGBO(48, 96, 53, 1.0);
Color secondColor = Color.fromRGBO(40, 123, 33, 1.0);

class MenuScreen extends StatelessWidget {
  static const routeName = '/MenuScreenRoute';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [firstColor, secondColor]),
        ),
        child: MenuOption(),
      ),
    );
  }
}
