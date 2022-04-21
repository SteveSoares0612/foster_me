import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/petDetails_screen.dart';
import '../models/animals.dart';
import 'package:provider/provider.dart';
import 'animal_item.dart';
import '../models/authentication.dart';

//Creating new class to assign and initiate values to new animals
//Creating new Widget which takes in assigned value animal list and favorite function
class petView extends StatefulWidget with ChangeNotifier {
  petView();

  static const routeName = '/petViewW';
  static var selectedCategoryValue = ValueNotifier('1');

  static String _category = '1';

  @override
  State<petView> createState() => _petViewState();

  String get getChosenCategory {
    return petView.selectedCategoryValue.value;
  }
}

class _petViewState extends State<petView> {
  var _isInit = true; //Set loader
  var _isloading = false;

  void selectPet(BuildContext ctx, String id) {
    Navigator.of(ctx).pushNamed(PetDetailsScreen.routeName, arguments: id);
  }

  Future<void> _refreshPets(BuildContext context) async {
    await Provider.of<Animals>(context, listen: false).fetchAndSetAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => _refreshPets(context),
        child: ValueListenableBuilder(
          valueListenable: petView.selectedCategoryValue,
          builder: (BuildContext context, String newValue, Widget child) {
            return FutureBuilder(
                future: Provider.of<Animals>(context, listen: false)
                    .fetchAndSetAnimals(),
                builder: (context, snapshotData) {
                  if (snapshotData.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Consumer<Animals>(builder: (ctx, animalsData, _) {
                      print(animalsData.animals[0].name);
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: animalsData.animals.length,
                        itemBuilder: (_, index) => Column(
                          children: [
                            Animal_item(
                              animalsData.animals[index].id,
                              animalsData.animals[index].name,
                              animalsData.animals[index].animal_Breed,
                              animalsData.animals[index].Image,
                              animalsData.animals[index].isMale,
                              animalsData.animals[index].age,
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      );
                    });
                  }
                });
          },
        ),
      ),

      //
    );
  }
}
