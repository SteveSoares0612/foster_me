import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/MainFoster_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/animals.dart';
import '../models/animal_categories.dart';
import 'petView.dart';
import 'package:provider/provider.dart';

class petOptions extends StatefulWidget {
  @override
  _petOptions createState() => _petOptions();
}

class _petOptions extends State<petOptions> {
  var selectedPetIcon = 0;

  final List<AnimalCategories> animalCategories = [
    AnimalCategories(
      id: '1',
      name: "Dogs",
      Image: "assets/Images/noun_Dog_2755593.png",
    ),
    AnimalCategories(
      id: '2',
      name: "Cats",
      Image: "assets/Images/noun_Cat_2755594.png",
    ),
    AnimalCategories(
      id: '3',
      name: "Birds",
      Image: "assets/Images/noun_Parrot_394593.png",
    ),
    AnimalCategories(
      id: '4',
      name: "Rodents",
      Image: "assets/Images/noun_Hamster_3378728.png",
    ),
    AnimalCategories(
      id: '5',
      name: "Others",
      Image: "assets/Images/6839887.png",
    ),
  ];

  Future<void> selectAnimal(BuildContext context, int index) async {
    selectedPetIcon = index;
    Provider.of<Animals>(context, listen: false).chosenCategory =
        petView.selectedCategoryValue.value;
    await Provider.of<Animals>(context, listen: false).fetchAndSetAnimals();
  }

  //Pet icon button creation
  Widget createPetIcons(
      BuildContext context, int index, String id, String name, String image) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 30.0,
      ),
      child: Column(
        children: <Widget>[
          //Change Selected on tap
          InkWell(
            //Send Selected Category ID to petView Widget
            onTap: () => setState(() {
              petView.selectedCategoryValue.value = id;
              selectAnimal(context, index);
            }),
            //Icon main box
            child: Container(
              decoration: BoxDecoration(
                  color: selectedPetIcon == index
                      ? Color.fromRGBO(27, 124, 16, 1)
                      : Color.fromRGBO(255, 255, 255, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(182, 182, 182, 0.5),
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      spreadRadius: 1,
                    )
                  ],
                  borderRadius: BorderRadius.circular(15)),
              //Icon
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ImageIcon(
                    AssetImage(image),
                    color: selectedPetIcon == index
                        ? Colors.white70
                        : Color.fromRGBO(182, 182, 182, 1),
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          //Icon Text
          Text(
            name,
            style: TextStyle(
                color: selectedPetIcon == index
                    ? Colors.black
                    : Color.fromRGBO(182, 182, 182, 1),
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 102,
          child: ListView.builder(
              padding: EdgeInsets.only(left: 18, top: 1),
              scrollDirection: Axis.horizontal,
              itemCount: animalCategories.length,
              itemBuilder: (context, index) {
                return createPetIcons(
                    context,
                    index,
                    animalCategories[index].id,
                    animalCategories[index].name,
                    animalCategories[index].Image);
              }),
        ),
      ],
    );
  }
}
