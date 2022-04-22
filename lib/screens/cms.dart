import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foster_me/models/animals.dart';
import '../widgets/image_input.dart';
import 'package:provider/provider.dart';
import '../models/animals.dart';
import '../models/animal.dart';
import '../models/authentication.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:another_flushbar/flushbar.dart';

import 'dart:io';

class CMS extends StatefulWidget {
  final Function menuCallback;
  CMS({@required this.menuCallback});
  static const routeName = '/cms';

  @override
  State<CMS> createState() => _CMSState();
}

class _CMSState extends State<CMS> {
  String categoryVal;
  String genderVal;
  String neutered;
  String vaccinated;
  String petSize;
  String needsTraining;
  String _activityLevel;
  String goodWithKids;
  String goodWithLargeFamilies;
  String _healthStatus;
  TextEditingController description = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController breed = new TextEditingController();
  TextEditingController Sname = new TextEditingController();
  TextEditingController age = new TextEditingController();

  String userID;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userID = Provider.of<Auth>(context, listen: false).users[0].UserID;
  }

  File _pickedImage;
  void _useImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  final categories = ['Dog', 'Cat', 'Bird', 'Rodent', 'Others'];
  final gender = ['Male', 'Female'];
  final health = ['Healthy', 'Moderate', 'Poor'];
  final activity = ['Quite', 'Moderate', 'Noisy'];
  final options = ['Yes', 'No'];
  final size = ['Small', 'Medium', 'Large'];

  var newPets = Animal(
      id: null,
      category: '',
      name: '',
      animal_Breed: '',
      Scientific_Name: '',
      age: 0,
      Image: '',
      isMale: false,
      isVacinnated: false,
      Spayed: false,
      description: '',
      size: '',
      createdBy: '',
      needsTraining: false,
      goodWithKids: false,
      goodWithLargeFamilies: false,
      healthStatus: '',
      activityLevel: '');

  Widget buildTexts(String Text, icon, TextEditingController controller) {
    return Container(
      width: 350,
      height: 70,
      decoration: BoxDecoration(),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: Icon(
            icon,
            size: 15,
          ),
          labelText: Text,
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    bool isMale;
    bool Vaccinated;
    bool spayed;
    bool _needsTraining;
    bool goodWkids;
    bool goodWFam;

    if (genderVal == "Male") {
      isMale = true;
    } else {
      isMale = false;
    }

    if (goodWithKids == 'Yes') {
      goodWkids = true;
    } else {
      goodWkids = false;
    }

    if (goodWithLargeFamilies == 'Yes') {
      goodWFam = true;
    } else {
      goodWFam = false;
    }

    if (needsTraining == "Yes") {
      _needsTraining = true;
    } else {
      _needsTraining = false;
    }

    if (vaccinated == "Yes") {
      Vaccinated = true;
    } else {
      Vaccinated = false;
    }

    if (categoryVal == "Dog") {
      categoryVal = '1';
    } else if (categoryVal == "Cat") {
      categoryVal = '2';
    } else if (categoryVal == "Bird") {
      categoryVal = '3';
    } else if (categoryVal == "Rodent") {
      categoryVal = '4';
    } else if (categoryVal == "Others") {
      categoryVal = '5';
    }

    if (neutered == "Yes") {
      spayed = true;
    } else {
      spayed = false;
    }

    String extension;
    if (_pickedImage.toString().contains('.jpg')) {
      extension = '.jpg';
    } else if (_pickedImage.toString().contains('.png')) {
      extension = '.png';
    } else {
      Flushbar(
        backgroundColor: Theme.of(context).primaryColor,
        message: 'Please pick an image (png or jpg)',
        duration: Duration(seconds: 2),
      ).show(context);
      return;
    }
    if (_pickedImage == null) {
      Flushbar(
        backgroundColor: Theme.of(context).primaryColor,
        message: 'Please Pick An Image',
        duration: Duration(seconds: 2),
      ).show(context);
      return;
    }

    final ref = FirebaseStorage.instance
        .ref()
        .child("pet_images")
        .child(name.text + extension);
    UploadTask uploadTask = ref.putFile(_pickedImage);
    final imageURL = await ref.getDownloadURL();
    print(imageURL);
    newPets = Animal(
      id: null,
      category: categoryVal,
      name: name.text,
      animal_Breed: breed.text,
      Scientific_Name: Sname.text,
      age: double.parse("${age.text}"),
      Image: imageURL,
      isMale: isMale,
      isVacinnated: Vaccinated,
      Spayed: spayed,
      description: description.text,
      size: petSize,
      createdBy: userID,
      needsTraining: _needsTraining,
      goodWithKids: goodWkids,
      goodWithLargeFamilies: goodWFam,
      healthStatus: _healthStatus,
      activityLevel: _activityLevel,
    );
    Provider.of<Animals>(context, listen: false)
        .addPet(newPets)
        .then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    // userID = Provider.of<Auth>(context, listen: false).loggedInUser;
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("FOSTER ME")],
            ),
            backgroundColor: Theme.of(context).primaryColor,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Add Pet",
                      style: TextStyle(color: Colors.white),
                    ),
                    Tab(icon: Icon(Icons.add, color: Colors.white)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Update Pet", style: TextStyle(color: Colors.white)),
                    Tab(
                        icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
                  ],
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            ImageInput(_useImage),
                            buildTexts(
                                "Enter Pet Name", FontAwesomeIcons.paw, name),
                            buildTexts("Enter Pet Breed",
                                FontAwesomeIcons.question, breed),
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Choose animal category"),
                                ),
                                underline: Container(),
                                value: categoryVal,
                                iconSize: 25,
                                items: categories
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(item),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (item) {
                                  setState(() {
                                    categoryVal = item as String;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            buildTexts("Enter Scientific Name",
                                FontAwesomeIcons.paw, Sname),
                            buildTexts("Enter Pet Age",
                                FontAwesomeIcons.calendar, age),
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Enter pet Size"),
                                ),
                                underline: Container(),
                                value: petSize,
                                iconSize: 25,
                                items: size
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(item),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (item) {
                                  setState(() {
                                    petSize = item as String;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              width: 350,
                              height: 70,
                              decoration: BoxDecoration(),
                              child: TextFormField(
                                controller: description,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    FontAwesomeIcons.book,
                                    size: 15,
                                  ),
                                  labelText: "Enter a Description",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a description.';
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Choose Gender"),
                                ),
                                underline: Container(),
                                value: genderVal,
                                iconSize: 25,
                                items: gender
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(item),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (item) {
                                  setState(() {
                                    genderVal = item as String;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Neutered?"),
                                ),
                                underline: Container(),
                                value: neutered,
                                iconSize: 25,
                                items: options
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(item),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (item) {
                                  setState(() {
                                    neutered = item as String;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Vacinnated?"),
                                ),
                                underline: Container(),
                                value: vaccinated,
                                iconSize: 25,
                                items: options
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(item),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (item) {
                                  setState(() {
                                    vaccinated = item as String;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Needs Training?"),
                                ),
                                underline: Container(),
                                value: needsTraining,
                                iconSize: 25,
                                items: options
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(item),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (item) {
                                  setState(() {
                                    needsTraining = item as String;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Household Preferred Activity Level"),
                                ),
                                underline: Container(),
                                value: _activityLevel,
                                iconSize: 25,
                                items: activity
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(item),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (item) {
                                  setState(() {
                                    _activityLevel = item as String;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Good With Kids?"),
                                ),
                                underline: Container(),
                                value: goodWithKids,
                                iconSize: 25,
                                items: options
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(item),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (item) {
                                  setState(() {
                                    goodWithKids = item as String;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Good With Families?"),
                                ),
                                underline: Container(),
                                value: goodWithLargeFamilies,
                                iconSize: 25,
                                items: options
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(item),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (item) {
                                  setState(() {
                                    goodWithLargeFamilies = item as String;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              width: 350,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Health Status"),
                                ),
                                underline: Container(),
                                value: _healthStatus,
                                iconSize: 25,
                                items: health
                                    .map((item) => DropdownMenuItem(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(item),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (item) {
                                  setState(() {
                                    _healthStatus = item as String;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              width: 350,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor),
                                onPressed: () {
                                  // Navigator.pop(context);
                                  _submitForm();
                                },
                                child: const Text(
                                  'SUBMIT',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          // buildTexts("Name", FontAwesomeIcons.paw),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

DropdownMenuItem<String> buildMenuCategory(String item) => DropdownMenuItem(
      value: item,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(item),
      ),
    );
