//Creating new class to assign and initiate values to new animals
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class Animal with ChangeNotifier {
  final String id;
  final String category;
  String name;
  String animal_Breed;
  String Scientific_Name;
  double age;
  bool isMale;
  String Image;
  bool isVacinnated;
  bool Spayed;
  String description;
  String size;
  String createdBy;
  bool needsTraining;
  String activityLevel;
  bool goodWithKids;
  bool goodWithLargeFamilies;
  String healthStatus;

  Animal({
    @required this.id,
    @required this.category,
    @required this.name,
    @required this.animal_Breed,
    @required this.Scientific_Name,
    @required this.age,
    @required this.Image,
    @required this.isMale,
    @required this.isVacinnated,
    @required this.Spayed,
    @required this.description,
    @required this.size,
    @required this.createdBy,
    @required this.needsTraining,
    @required this.activityLevel,
    @required this.goodWithKids,
    @required this.goodWithLargeFamilies,
    @required this.healthStatus,
  });
}
