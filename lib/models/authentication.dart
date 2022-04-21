import 'dart:developer';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'fosterApplication.dart';
import 'package:foster_me/models/httpException.dart';
import 'package:foster_me/models/users.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../screens/MainFoster_screen.dart';
import 'dart:developer';
import 'dart:math';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  String loggedInUser;
  bool isAdmin;
  bool formFilled;
  List<User> users = [];
  List<User> allusers = [];

  bool get auth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  bool get admin {
    return isAdmin;
  }

  User findUserById(String id) {
    return allusers.firstWhere((user) => user.UserID == id);
  }

  User findUserByAuthId(String id) {
    return allusers.firstWhere((user) => user.AuthUserID == id);
  }

  Future<void> _authenticate(
      String email, String password, String UrlSeg) async {
    try {
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$UrlSeg?key=AIzaSyCl9X4uS0p_cI8uUOEPAgd05kY29TivSy8');
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HTTPException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUpUser(String email, String password) async {
    return _authenticate(email, password, 'signUp').then((value) {
      loggedInUser = _userId;
    }).then(
      (value) => addUser(email, password).then(
        (value) => fetchAndSetLoggedInUser().then(
          (value) => getAllUsers(),
        ),
      ),
    );
  }

  Future<void> loginUser(String email, String password) {
    return _authenticate(email, password, "signInWithPassword").then((value) {
      loggedInUser = _userId;
    }).then(
        (value) => fetchAndSetLoggedInUser().then((value) => getAllUsers()));
  }

  Future<void> fetchAndSetLoggedInUser() async {
    final url =
        'https://fosterme-7-default-rtdb.firebaseio.com/Users.json?auth=$_token&orderBy="UserId"&equalTo="$loggedInUser"';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<User> loadedUsers = [];
      extractedData.forEach((userID, userData) {
        try {
          loadedUsers.add(
            User(
              UserID: userID,
              AuthUserID: userData['UserId'],
              Email: userData['Email'],
              isAdmin: userData['isAdmin'],
              formFilled: userData['formFilled'],
              Country: userData['Country'],
              City: userData['city'],
              phoneNo: userData['phoneNo'],
              fullName: userData['fullName'],
              Address: userData['address'],
              age: userData['age'],
              agreeForfoster: userData['agreeForfoster'],
              allergies: userData['allergies'],
              driver: userData['driver'],
              householdPeoplelist: userData['householdPeoplelist'],
              noOffamilyMembers: userData['noOffamilyMembers'],
              phoneNoWrk: userData['phoneNoWrk'],
              selectedGender: userData['selectedGender'],
              selectedHouseOcc: userData['selectedHouseOcc'],
              selectedHouseType: userData['selectedHouseType'],
              selectedSize: userData['selectedSize'],
              selectedactivityLevel: userData['selectedactivityLevel'],
              willingToTrain: userData['willingToTrain'],
              willingTotakeToVet: userData['willingTotakeToVet'],
              description: userData['description'],
              profileImage: userData['profileImage'],
            ),
          );
        } catch (e) {}
      });
      users = loadedUsers;
      isAdmin = users[0].isAdmin;
      formFilled = users[0].formFilled;
      notifyListeners();
    } catch (error) {
      // print("This error : " + error);
    }
  }

  Future<void> getAllUsers() async {
    final url = 'https://fosterme-7-default-rtdb.firebaseio.com/Users.json?';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      final List<User> loadedUsers = [];
      extractedData.forEach((userID, userData) {
        try {
          loadedUsers.add(
            User(
              UserID: userID,
              AuthUserID: userData['UserId'],
              Email: userData['Email'],
              isAdmin: userData['isAdmin'],
              formFilled: userData['formFilled'],
              Country: userData['Country'],
              City: userData['city'],
              phoneNo: userData['phoneNo'],
              fullName: userData['fullName'],
              Address: userData['address'],
              age: userData['age'],
              agreeForfoster: userData['agreeForfoster'],
              allergies: userData['allergies'],
              driver: userData['driver'],
              householdPeoplelist: userData['householdPeoplelist'],
              noOffamilyMembers: userData['noOffamilyMembers'],
              phoneNoWrk: userData['phoneNoWrk'],
              selectedGender: userData['selectedGender'],
              selectedHouseOcc: userData['selectedHouseOcc'],
              selectedHouseType: userData['selectedHouseType'],
              selectedSize: userData['selectedSize'],
              selectedactivityLevel: userData['selectedactivityLevel'],
              willingToTrain: userData['willingToTrain'],
              willingTotakeToVet: userData['willingTotakeToVet'],
              description: userData['description'],
              profileImage: userData['profileImage'],
            ),
          );
        } catch (e) {}
      });
      allusers = loadedUsers;
      notifyListeners();
    } catch (error) {
      // print("This error : " + error);
    }
  }

  Future<void> addUser(
    String email,
    String password,
  ) async {
    try {
      final url = Uri.parse(
          'https://fosterme-7-default-rtdb.firebaseio.com/Users.json?');
      http
          .post(
        url,
        body: json.encode({
          'UserId': _userId,
          'Email': email,
          'isAdmin': false,
          'formFilled': false,
          'fullName': '',
          'phoneNo': '',
          'city': '',
          'Country': '',
          'address': '',
          'age': '',
          'agreeForfoster': '',
          'allergies': '',
          'driver': '',
          'householdPeoplelist': '',
          'noOffamilyMembers': '',
          'phoneNoWrk': '',
          'selectedGender': '',
          'selectedHouseOcc': '',
          'selectedHouseType': '',
          'selectedSize': '',
          'selectedactivityLevel': '',
          'willingToTrain': '',
          'willingTotakeToVet': '',
          'description': '',
          'profileImage': '',
        }),
      )
          .then((response) {
        print(response);
      });
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      print(extractedData);
    } catch (e) {}
  }

  Future<void> updateUser(String id, User newUser) async {
    // final userIndex = users.indexWhere((user) => user.UserID == id);
    print("Id =  ${id}");
    print("Id =  ${users[0].UserID}");
    final url = Uri.parse(
        'https://fosterme-7-default-rtdb.firebaseio.com/Users/$id.json?');
    print(newUser.fullName);
    http.patch(
      url,
      body: json.encode(
        {
          'fullName': newUser.fullName,
          'phoneNo': newUser.phoneNo,
          'city': newUser.City,
          'Country': newUser.Country,
          'address': newUser.Address,
          'formFilled': true,
          'age': newUser.age,
          'agreeForfoster': newUser.agreeForfoster,
          'allergies': newUser.allergies,
          'driver': newUser.driver,
          'householdPeoplelist': newUser.householdPeoplelist,
          'noOffamilyMembers': newUser.noOffamilyMembers,
          'phoneNoWrk': newUser.phoneNoWrk,
          'selectedGender': newUser.selectedGender,
          'selectedHouseOcc': newUser.selectedHouseOcc,
          'selectedHouseType': newUser.selectedHouseType,
          'selectedSize': newUser.selectedSize,
          'selectedactivityLevel': newUser.selectedactivityLevel,
          'willingToTrain': newUser.willingToTrain,
          'willingTotakeToVet': newUser.willingTotakeToVet,
          'hasKids': newUser.hasKids,
        },
      ),
    );
    notifyListeners();
  }

  Future<void> updateAdminUser(String id, User newUser) async {
    // final userIndex = users.indexWhere((user) => user.UserID == id);
    print("Image " + "${newUser.profileImage}");
    final url = Uri.parse(
        'https://fosterme-7-default-rtdb.firebaseio.com/Users/$id.json?');
    print(newUser.fullName);
    http.patch(
      url,
      body: json.encode(
        {
          'fullName': newUser.fullName,
          'phoneNo': newUser.phoneNo,
          'city': newUser.City,
          'Country': newUser.Country,
          'address': newUser.Address,
          'formFilled': true,
          'description': newUser.description,
          'profileImage': newUser.profileImage,
        },
      ),
    );

    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  Future<void> addApplication(FApplication application) async {
    print("HELLLLLLLLLLLLLLLLLLLLLO");
    final url =
        'https://fosterme-7-default-rtdb.firebaseio.com/Applications.json?';
    http
        .post(
      Uri.parse(url),
      body: json.encode({
        'AnimalID': application.animalid,
        'animalcategory': application.animalcategory,
        'Animalname': application.Animalname,
        'animal_Breed': application.animal_Breed,
        'animalcreatedBy': application.animalcreatedBy,
        'animalisMale': application.animalisMale,
        'UserID': application.UserID,
        'Address': application.Address,
        'Country': application.Country,
        'Email': application.Email,
        'age': application.age,
        'agreeForfoster': application.agreeForfoster,
        'allergies': application.allergies,
        'description': application.description,
        'driver': application.driver,
        'fullName': application.fullName,
        'hasKids': application.hasKids,
        'householdPeoplelist': application.householdPeoplelist,
        'noOffamilyMembers': application.noOffamilyMembers,
        'phoneNo': application.phoneNo,
        'phoneNoWrk': application.phoneNoWrk,
        'selectedGender': application.selectedGender,
        'selectedHouseOcc': application.selectedHouseOcc,
        'selectedHouseType': application.selectedHouseType,
        'selectedSize': application.selectedSize,
        'selectedactivityLevel': application.selectedactivityLevel,
        'willingToTrain': application.willingToTrain,
        'willingTotakeToVet': application.willingTotakeToVet,
      }),
    )
        .then((response) {
      print(response);
    });
    final response = await http.get(Uri.parse(url));
    final extractedData = json.decode(response.body);
    print(extractedData);
  }
}
