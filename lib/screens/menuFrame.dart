import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foster_me/screens/MainFoster_screen.dart';
import 'package:foster_me/screens/cms.dart';
import 'package:foster_me/screens/profile_screen.dart';
import 'menu_screen.dart';
import 'package:provider/provider.dart';

class MenuFrame extends StatefulWidget {
  @override
  final bool isAdmin;
  MenuFrame(this.isAdmin);
  State<MenuFrame> createState() => _MenuFrameState();
}

class _MenuFrameState extends State<MenuFrame>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Duration duration = Duration(milliseconds: 200);
  Animation<double> scaleAnimation, scaleAnimation2;
  bool menuOpen = true;
  List<Animation> scaleAnimations;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: duration);
    scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(animationController);
    scaleAnimation2 =
        Tween<double>(begin: 1.0, end: 0.7).animate(animationController);
    scaleAnimations = [
      Tween<double>(begin: 1.0, end: 0.8).animate(animationController),
      Tween<double>(begin: 1.0, end: 0.7).animate(animationController),
      Tween<double>(begin: 1.0, end: 0.6).animate(animationController),
    ];
    animationController.forward();
    adminScreenSnapshot = adminpages.values.toList();
    userScreenSnapshot = userpages.values.toList();
  }

  Map<int, Widget> adminpages = {
    // Main_Foster(menuCallback: () {
    //   setState(() {
    //     menuOpen = true;
    //     animationController.forward();
    //   });
    // }),
    // ProfileScreen(menuCallback: () {}),
    // CMS(menuCallback: () {}),
    0: Container(
      color: Colors.red,
    ),
    1: Container(
      color: Colors.blue,
    ),
    2: Container(
      color: Colors.white,
    ),
  };

  Map<int, Widget> userpages = {
    // Main_Foster(menuCallback: () {
    //   setState(() {
    //     menuOpen = true;
    //     animationController.forward();
    //   });
    // }),
    // ProfileScreen(menuCallback: () {}),
    // CMS(menuCallback: () {}),
    0: Container(
      color: Colors.red,
    ),
    1: Container(
      color: Colors.blue,
    ),
  };

  List<Widget> adminScreenSnapshot;
  List<Widget> userScreenSnapshot;

  List<Widget> finalPageStack() {
    List<Widget> returnStack = [];
    returnStack.add(MenuScreen(
      menuCallback: (selectedIndex) {
        if (widget.isAdmin) {
          setState(() {
            final selectedWidget = adminScreenSnapshot.removeAt(selectedIndex);
            adminScreenSnapshot.insert(0, selectedWidget);
          });
        } else {
          setState(() {
            final selectedWidget = userScreenSnapshot.removeAt(selectedIndex);
            userScreenSnapshot.insert(0, selectedWidget);
          });
        }
      },
    ));
    if (widget.isAdmin) {
      adminScreenSnapshot
          .asMap()
          .entries
          .map((screen) => buildPageStack(screen.key, adminScreenSnapshot))
          .toList()
          .reversed
        ..forEach((screen) {
          returnStack.add(screen);
        });
    } else {
      userScreenSnapshot
          .asMap()
          .entries
          .map((screen) => buildPageStack(screen.key, userScreenSnapshot))
          .toList()
          .reversed
        ..forEach((screen) {
          returnStack.add(screen);
        });
    }

    return returnStack;
  }

  Widget buildPageStack(int place, List<Widget> pageList) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return AnimatedPositioned(
      duration: duration,
      top: menuOpen ? deviceWidth * 0.10 : 0.0,
      bottom: 0,
      left: menuOpen ? deviceWidth * 0.40 - (place * 30) : 0.0,
      right: menuOpen ? deviceWidth * -0.130 + (place * 30) : 0.0,
      child: ScaleTransition(
        scale: scaleAnimations[place],
        child: GestureDetector(
          onTap: () {
            if (!mounted)
              return;
            else if (menuOpen) {
              setState(() {
                menuOpen = false;
                animationController.reverse();
              });
            }
          },
          child: AbsorbPointer(
            absorbing: menuOpen,
            child: Stack(
              children: [
                Material(
                  animationDuration: duration,
                  borderRadius: BorderRadius.circular(menuOpen ? 20.0 : 0.0),
                  child: pageList[place],
                ),
                // Container(
                //   color: Theme.of(context).primaryColor.withOpacity(0.5),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:
          // ProfileScreen(),
          // MenuScreen(),
          finalPageStack(),
    );
  }
}
