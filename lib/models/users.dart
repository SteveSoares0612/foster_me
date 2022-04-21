//Creating new class to assign and initiate values to new animals
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:foster_me/models/httpException.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class User with ChangeNotifier {
  final String AuthUserID;
  final String profileImage;
  final String UserID;
  final String Email;
  final String fullName;
  final String Country;
  final String City;
  final String Address;
  final String phoneNo;
  final String phoneNoWrk;
  final String age;
  final String selectedHouseType;
  final String selectedHouseOcc;
  final String selectedactivityLevel;
  final String householdPeoplelist;
  final String allergies;
  final String agreeForfoster;
  final String selectedGender;
  final String selectedSize;
  final String willingTotakeToVet;
  final String driver;
  final String willingToTrain;
  final String noOffamilyMembers;
  final String description;
  final String hasKids;
  bool isAdmin;
  bool formFilled;

  User(
      {this.UserID,
      @required this.AuthUserID,
      this.profileImage,
      @required this.Email,
      @required this.isAdmin,
      @required this.formFilled,
      this.fullName,
      this.Country,
      this.City,
      this.Address,
      this.phoneNo,
      this.age,
      this.agreeForfoster,
      this.allergies,
      this.driver,
      this.householdPeoplelist,
      this.noOffamilyMembers,
      this.phoneNoWrk,
      this.selectedGender,
      this.selectedHouseOcc,
      this.selectedHouseType,
      this.selectedSize,
      this.selectedactivityLevel,
      this.willingToTrain,
      this.willingTotakeToVet,
      this.description,
      this.hasKids});
}
