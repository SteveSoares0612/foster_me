import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foster_me/screens/MainFoster_screen.dart';
import 'menu_screen.dart';

class MenuFrame extends StatefulWidget {
  @override
  State<MenuFrame> createState() => _MenuFrameState();
}

class _MenuFrameState extends State<MenuFrame>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Duration duration = Duration(milliseconds: 200);
  Animation<double> scaleAnimation;
  bool menuOpen = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: duration);
    scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        MenuScreen(),
        AnimatedPositioned(
          duration: duration,
          top: menuOpen ? deviceWidth * 0.10 : 0.0,
          bottom: 0,
          left: menuOpen ? deviceWidth * 0.55 : 0.0,
          right: menuOpen ? deviceWidth * -0.130 : 0.0,
          child: ScaleTransition(
            scale: scaleAnimation,
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
                child: Material(
                  animationDuration: duration,
                  borderRadius: BorderRadius.circular(menuOpen ? 20.0 : 0.0),
                  child: Main_Foster(
                    menuCallback: () {
                      if (mounted) {
                        setState(() {
                          menuOpen = true;
                          animationController.forward();
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
