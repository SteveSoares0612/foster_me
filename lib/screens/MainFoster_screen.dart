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
import 'petBreedFinder_screen.dart';

class Main_Foster extends StatefulWidget with ChangeNotifier {
  final Function menuCallback;
  int PetIconIndex = 0;
  static TextEditingController searchString = new TextEditingController();
  static const routeName = "/mainFoster";
  String search = "Search";

  Main_Foster({@required this.menuCallback});

  @override
  State<Main_Foster> createState() => _Main_FosterState();

  String get getSearchString {
    return search;
  }
}

class _Main_FosterState extends State<Main_Foster> {
  bool isFavorite = false;

  void _Favorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> _searchPets(BuildContext context) async {
    Provider.of<Animals>(context, listen: false).searchString =
        Main_Foster.searchString.text;
    await Provider.of<Animals>(context, listen: false).searchAndSetAnimals();
  }

  void openBreedDetector(BuildContext context) {
    Navigator.of(context).pushNamed(DetermineBreed.routeName);
  }

  Color greyColor = Color.fromRGBO(245, 245, 245, 1);

  //**********Main UI ****/
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    String categoryID = '1';
    // categoryID = ModalRoute.of(context)!.settings.arguments as String;
    return Padding(
      padding: const EdgeInsets.only(
        top: 0.0,
      ),
      child: Column(
        children: <Widget>[
          AppBar(
            centerTitle: true,
            title: Image.asset('assets/Images/logo.png', height: 120),
            backgroundColor: Color.fromRGBO(245, 245, 245, 1),
            elevation: 0,
            toolbarHeight: 80,
            leading: IconButton(
              onPressed: () {},
              icon: InkWell(
                child: Tab(
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onTap: widget.menuCallback,
              ),
            ),
          ),

          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 22.0),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       InkWell(
          //         child: Tab(
          //           icon: Icon(Icons.menu),
          //         ),
          //         onTap: widget.menuCallback,
          //       ),
          //       Image.asset('assets/Images/logo.png', height: 100),
          //       IconButton(
          //         onPressed: () => openBreedDetector(context),
          //         icon: const Icon(FontAwesomeIcons.paw),
          //         color: Theme.of(context).primaryColor,
          //       )
          //     ],
          //   ),
          // ),
          Expanded(
            //main background Widget
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: Column(
                  children: <Widget>[
                    //Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 18),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(245, 245, 245, 1),
                            borderRadius: BorderRadius.circular(14)),
                        padding: EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.search,
                              color: Colors.grey,
                              size: 18,
                            ),
                            Expanded(
                              child: TextField(
                                controller: Main_Foster.searchString,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(
                                        left: 8,
                                        bottom: 11,
                                        top: 12,
                                        right: 15),
                                    hintText: "Search for a new companion"),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(182, 182, 182, 1),
                                ),
                                onChanged: (_) => _searchPets(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Icon Buttons
                    petOptions(),
                    //Available pets widget
                    petView(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
