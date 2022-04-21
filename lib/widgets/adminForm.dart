import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foster_me/models/authentication.dart';
import 'package:foster_me/models/users.dart';
import 'package:provider/provider.dart';
import '../models/authentication.dart';
import 'image_input.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:another_flushbar/flushbar.dart';

import 'dart:io';

class adminForm extends StatefulWidget {
  @override
  State<adminForm> createState() => _adminFormState();
}

class _adminFormState extends State<adminForm> {
  TextEditingController _fullname = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _location = new TextEditingController();
  TextEditingController _City = new TextEditingController();
  TextEditingController _Country = new TextEditingController();
  TextEditingController _phoneNo = new TextEditingController();
  TextEditingController profilePic = new TextEditingController(); //NEEDED
  int month;
  int day;
  int year;

  var _editedAdminUser = User(
    formFilled: false,
    fullName: '',
    Country: '',
    City: '',
    Address: '',
    phoneNo: '',
    description: '',
    profileImage: '',
  );

  File _pickedImage;
  void _useImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  String userId;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = Provider.of<Auth>(context, listen: false).users[0].UserID;
  }

  Future<void> updateAdminUser() async {
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
    if ((_fullname.text == '' || null) ||
        (_Country.text == '' || null) ||
        (_City.text == '' || null) ||
        (_location.text == '' || null) ||
        (_phoneNo.text == '' || null) ||
        (_description.text == '' || null)) {
      Flushbar(
        backgroundColor: Theme.of(context).primaryColor,
        message: 'Please Enter All Textfields',
        duration: Duration(seconds: 2),
      ).show(context);
      return;
    }
    final ref = FirebaseStorage.instance
        .ref()
        .child("user_images")
        .child(userId + extension);
    UploadTask uploadTask = ref.putFile(_pickedImage);
    final imageURL = await ref.getDownloadURL();

    _editedAdminUser = User(
      formFilled: true,
      fullName: _fullname.text,
      Country: _Country.text,
      City: _City.text,
      Address: _location.text,
      phoneNo: _phoneNo.text,
      description: _description.text,
      profileImage: imageURL,
    );

    Provider.of<Auth>(context, listen: false)
        .updateAdminUser(userId, _editedAdminUser)
        .then((value) => Provider.of<Auth>(context, listen: false)
            .fetchAndSetLoggedInUser());
  }

  Widget _buildStringText(BuildContext context, String Title, String hintText,
      TextEditingController controller) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                Title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              hintText: hintText, // pass the hint text parameter here
              hintStyle: TextStyle(color: Colors.grey),
            ),
            style: TextStyle(color: Colors.black),
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildStringText(
                context, "Full Name", "ex: John Nicholas", _fullname),
            _buildStringText(
                context, "Enter Your Email *", "ex: someone@gmail.com", _email),
            _buildStringText(context, "Enter Your Phone Number (Home) *",
                "ex: +971 55 0000000", _phoneNo),
            _buildStringText(context, "Tell Us About Your Organisation *",
                "say Something...", _description),
            _buildStringText(context, "Enter Your Loccation *",
                "ex: knowledge village, block 3", _location),
            _buildStringText(context, "Enter Your City", "ex: Dubai", _City),
            _buildStringText(context, "Enter Your Country",
                "ex: United Arab Emirates", _Country),
            ImageInput(_useImage),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                    onPressed: () {
                      updateAdminUser();
                    },
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
