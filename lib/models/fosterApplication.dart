import 'package:flutter/widgets.dart';

class FApplication with ChangeNotifier {
  final String animalid;
  final String animalcategory;
  String Animalname;
  String animal_Breed;
  bool animalisMale;
  String animalcreatedBy;
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

  FApplication({
    @required this.animalid,
    @required this.animalcategory,
    @required this.Animalname,
    @required this.animal_Breed,
    @required this.animalcreatedBy,
    @required this.animalisMale,
    @required this.UserID,
    @required this.Address,
    @required this.City,
    @required this.Country,
    @required this.Email,
    @required this.age,
    @required this.agreeForfoster,
    @required this.allergies,
    @required this.description,
    @required this.driver,
    @required this.fullName,
    @required this.hasKids,
    @required this.householdPeoplelist,
    @required this.noOffamilyMembers,
    @required this.phoneNo,
    @required this.phoneNoWrk,
    @required this.selectedGender,
    @required this.selectedHouseOcc,
    @required this.selectedHouseType,
    @required this.selectedSize,
    @required this.selectedactivityLevel,
    @required this.willingToTrain,
    @required this.willingTotakeToVet,
  });
}
