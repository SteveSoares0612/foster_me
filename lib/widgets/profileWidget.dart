import 'package:flutter/material.dart';

class profileWidget extends StatefulWidget {
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
  final String noOffamilyMembers;
  final String description;

  profileWidget({
    @required this.UserID,
    @required this.AuthUserID,
    @required this.profileImage,
    @required this.Email,
    @required this.fullName,
    @required this.Country,
    @required this.City,
    @required this.Address,
    @required this.phoneNo,
    @required this.age,
    @required this.noOffamilyMembers,
    @required this.phoneNoWrk,
    @required this.description,
  });
  @override
  State<profileWidget> createState() => _profileWidgetState();
}

class _profileWidgetState extends State<profileWidget> {
  @override
  Widget buildTitle(String title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget buildContent(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 15.0, bottom: 15, right: 15),
      child: Container(
        width: double.infinity,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w100,
              color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 244, 245, 244),
                      Color.fromARGB(255, 183, 192, 188),
                    ],
                  ),
                ),
                width: double.infinity,
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: widget.profileImage == ''
                          ? AssetImage("assets/Images/user.png")
                          : NetworkImage(widget.profileImage),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(widget.fullName,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w700))
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                buildTitle("Email"),
                buildContent(widget.Email),
                SizedBox(
                  height: 5,
                ),
                buildTitle("Address"),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 15.0, bottom: 15, right: 15),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      widget.Address +
                          ' ,' +
                          widget.City +
                          ' ,' +
                          widget.Country,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w100,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                buildTitle("Age"),
                widget.age != ''
                    ? buildContent(widget.age)
                    : buildContent("N/A"),
                SizedBox(
                  height: 5,
                ),
                buildTitle("Phone Number (Home)"),
                buildContent(widget.phoneNo),
                SizedBox(
                  height: 5,
                ),
                buildTitle("Phone Number (Work)"),
                buildContent(widget.phoneNoWrk),
                SizedBox(
                  height: 5,
                ),
                buildTitle("Number of Family Members"),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 15.0, bottom: 15, right: 15),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      'You have ' +
                          widget.noOffamilyMembers +
                          ' in your family',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w100,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                buildTitle("Description"),
                widget.description != ''
                    ? buildContent(widget.description)
                    : buildContent("N/A"),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
