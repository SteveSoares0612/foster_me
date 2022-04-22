//Creating new class to assign and initiate values to new animals
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:foster_me/models/httpException.dart';
import 'package:foster_me/widgets/petView.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'animal.dart';
import 'package:intl/intl.dart';

class Animals with ChangeNotifier {
  final String authToken;
  String chosenCategory;
  String searchString;

  List<Animal> _animals = [];

  List<Animal> get animals {
    return [..._animals];
  }

  Animals(
    this.authToken,
    this.chosenCategory,
    this._animals,
  );

  Animal findById(String id) {
    return _animals.firstWhere((animal) => animal.id == id);
  }

  List<Animal> get filterByCat {
    return _animals.where((prodItem) => prodItem.category == '1').toList();
  }

  Future<void> fetchAndSetAnimals() async {
    final url =
        'https://fosterme-7-default-rtdb.firebaseio.com/Animals.json?auth=$authToken&orderBy="category"&equalTo="$chosenCategory"';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Animal> loadedAnimals = [];
      extractedData.forEach((animalID, AnimalData) {
        try {
          loadedAnimals.add(Animal(
            id: animalID,
            name: AnimalData['name'],
            category: AnimalData['category'],
            animal_Breed: AnimalData['animal_Breed'],
            Scientific_Name: AnimalData['Scientific_Name'],
            age: double.parse("${AnimalData['age']}"),
            Image: AnimalData['Image'],
            isMale: AnimalData['isMale'],
            isVacinnated: AnimalData['isVacinnated'],
            Spayed: AnimalData['Spayed'],
            size: AnimalData['size'],
            description: AnimalData['description'],
            goodWithKids: AnimalData['goodWithKids'],
            goodWithLargeFamilies: AnimalData['goodWithLargeFamilies'],
            healthStatus: AnimalData['healthStatus'],
            needsTraining: AnimalData['needsTraining'],
            activityLevel: AnimalData['activityLevel'],
            createdBy: AnimalData['createdBy'],
          ));
        } catch (e) {
          log("Error $e", name: "Error: ");
        }
      });
      _animals = loadedAnimals;
      notifyListeners();
    } catch (error) {
      // print("This error : " + error);
    }
  }

  Future<void> searchAndSetAnimals() async {
    log("$searchString", name: "Search Value");
    final url =
        'https://fosterme-7-default-rtdb.firebaseio.com/Animals.json?auth=$authToken&orderBy="animal_Breed"&equalTo="$searchString"';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Animal> loadedAnimals = [];
      extractedData.forEach((animalID, AnimalData) {
        try {
          loadedAnimals.add(Animal(
            id: animalID,
            name: AnimalData['name'],
            category: AnimalData['category'],
            animal_Breed: AnimalData['animal_Breed'],
            Scientific_Name: AnimalData['Scientific_Name'],
            age: double.parse("${AnimalData['age']}"),
            Image: AnimalData['Image'],
            isMale: AnimalData['isMale'],
            isVacinnated: AnimalData['isVacinnated'],
            Spayed: AnimalData['Spayed'],
            size: AnimalData['size'],
            description: AnimalData['description'],
            createdBy: AnimalData['createdBy'],
          ));
        } catch (e) {
          log("Error $e", name: "Error: ");
        }
      });
      _animals = loadedAnimals;
      notifyListeners();
    } catch (error) {
      // print("This error : " + error);
    }
  }

  Future<void> addPet(Animal animal) async {
    final url = 'https://fosterme-7-default-rtdb.firebaseio.com/Animals.json?';
    http
        .post(
      Uri.parse(url),
      body: json.encode(
        {
          'Image': animal.Image,
          'Scientific_Name': animal.Scientific_Name,
          'Spayed': animal.Spayed,
          'age': animal.age,
          'animal_Breed': animal.animal_Breed,
          'category': animal.category,
          'description': animal.description,
          'isMale': animal.isMale,
          'isVacinnated': animal.isVacinnated,
          'name': animal.name,
          'size': animal.size,
          'createdBy': animal.createdBy,
          'goodWithKids': animal.goodWithKids,
          'goodWithLargeFamilies': animal.goodWithLargeFamilies,
          'healthStatus': animal.healthStatus,
          'needsTraining': animal.needsTraining,
          'activityLevel': animal.activityLevel
        },
      ),
    )
        .then((response) {
      final newPet = Animal(
          category: animal.category,
          name: animal.name,
          animal_Breed: animal.animal_Breed,
          Scientific_Name: animal.Scientific_Name,
          age: animal.age,
          Image: animal.Image,
          isMale: animal.isMale,
          isVacinnated: animal.isVacinnated,
          Spayed: animal.Spayed,
          description: animal.description,
          size: animal.size,
          createdBy: animal.createdBy);
      _animals.add(newPet);
      notifyListeners();
    });
  }

  Future<void> deleteAnimal(String id) async {
    final url =
        'https://fosterme-7-default-rtdb.firebaseio.com/Animals/$id.json';
    log(id, name: "Animal ID");
    try {
      await http.delete(Uri.parse(url));
    } catch (error) {
      // print("This error : " + error);
    }
  }
}
