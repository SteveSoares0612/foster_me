import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foster_me/screens/menu_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foster_me/screens/petBreedFinder_screen.dart';
import '../screens/MainFoster_screen.dart';

class appBar extends StatelessWidget {
  void openMenu(BuildContext context) {
    Navigator.of(context).pushNamed(MenuScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              // openMenu(context);
            },
            child: Tab(
              icon: SvgPicture.asset("assets/Images/menu.svg"),
            ),
          ),
          // Container(
          //   width: 100,
          //   child: Image(
          //     image: AssetImage("assets/Images/logo.png"),
          //     fit: BoxFit.contain,
          //   ),
          // ),
          // CircleAvatar(
          //   radius: 20.0,
          //   backgroundImage: AssetImage("assets/Images/account.jpg"),
          // )
          // IconButton(
          //   onPressed: () => openBreedDetector(context),
          //   icon: const Icon(FontAwesomeIcons.paw),
          //   color: Theme.of(context).primaryColor,
          // )
        ],
      ),
    );
  }
}
