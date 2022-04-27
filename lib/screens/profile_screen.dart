import 'package:flutter/material.dart';
import 'package:foster_me/widgets/profileWidget.dart';
import 'package:provider/provider.dart';
import '../models/authentication.dart';

class ProfileScreen extends StatefulWidget {
  final Function menuCallback;
  ProfileScreen({@required this.menuCallback});
  static const routeName = '/userProfile';
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Profile"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<Auth>(
        builder: (ctx, userData, _) {
          if (userData.Users.length == 0) {
            return Text("No users");
          } else {
            return ListView.builder(
                itemCount: userData.Users.length,
                itemBuilder: (_, index) => profileWidget(
                    UserID: userData.users[index].UserID,
                    AuthUserID: userData.users[index].AuthUserID,
                    profileImage: userData.users[index].profileImage,
                    Email: userData.users[index].Email,
                    fullName: userData.users[index].fullName,
                    Country: userData.users[index].Country,
                    City: userData.users[index].City,
                    Address: userData.users[index].Address,
                    phoneNo: userData.users[index].phoneNo,
                    age: userData.users[index].age,
                    noOffamilyMembers: userData.users[index].noOffamilyMembers,
                    phoneNoWrk: userData.users[index].phoneNoWrk,
                    description: userData.users[index].description));
          }
        },
      ),
    );
  }
}
