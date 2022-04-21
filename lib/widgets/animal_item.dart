import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foster_me/models/animals.dart';
import 'package:foster_me/models/users.dart';
import 'package:foster_me/widgets/adminForm.dart';
import '../screens/petDetails_screen.dart';
import 'package:provider/provider.dart';
import '../models/authentication.dart';
import 'userForm.dart';
import '../models/animal.dart';

class Animal_item extends StatefulWidget with ChangeNotifier {
  Animal_item(
      this.id, this.name, this.animal_Breed, this.image, this.isMale, this.age);

  final double age;
  final String animal_Breed;
  final String id;
  final String image;
  final bool isMale;
  final String name;

  @override
  State<Animal_item> createState() => _Animal_itemState();
}

class _Animal_itemState extends State<Animal_item> {
  bool formFilled;
  bool isAdmin;
  Animal selectedAnimal;
  String LoggedInUserID;
  User currentUser;

  @override
  void didChangeDependencies() {
    isAdmin = Provider.of<Auth>(context, listen: false).users[0].isAdmin;
    formFilled = Provider.of<Auth>(context, listen: false).users[0].formFilled;
    selectedAnimal = Provider.of<Animals>(
      context,
      listen: false,
    ).findById(widget.id);
    LoggedInUserID = Provider.of<Auth>(context, listen: false).loggedInUser;
    currentUser = Provider.of<Auth>(context, listen: false)
        .findUserByAuthId(LoggedInUserID);
    super.didChangeDependencies();
  }

  void selectPet(BuildContext ctx, String id) {
    Navigator.of(ctx).pushNamed(PetDetailsScreen.routeName, arguments: id);
  }

  showConfirmationDialog(BuildContext context, String id) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
      onPressed: () => Provider.of<Animals>(context, listen: false)
          .deleteAnimal(id)
          .then((value) => Navigator.pop(context))
          .then(
            (value) => _refreshPets(context),
          ),
      child: Text(
        "Delete",
        style: TextStyle(color: Colors.white),
      ),
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Confirmation",
        style: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700),
      ),
      content: Text(
          "Are you sure you want to delete this animal from the database?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showErrorDialog(BuildContext context) {
    Widget closeButton = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
      onPressed: () => Navigator.pop(context),
      child: Text(
        "Close",
        style: TextStyle(color: Colors.white),
      ),
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Oops..",
        style: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700),
      ),
      content: Text("You cannot delete listings that aren't created by you."),
      actions: [
        closeButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _refreshPets(BuildContext context) async {
    await Provider.of<Animals>(context, listen: false).fetchAndSetAnimals();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => {
        if (formFilled == false)
          {
            if (isAdmin == true)
              {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text('Admin Information'),
                      content: adminForm(),
                    );
                  },
                ),
              }
            else
              {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text('User Information'),
                      content: UserForm(),
                    );
                  },
                ),
              }
            //
          }
        else
          {
            selectPet(context, widget.id),
          }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 10.0,
          right: 20.0,
          left: 20.0,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerLeft,
          children: [
            Material(
              borderRadius: BorderRadius.circular(20.0),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 225,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  height: 170,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              widget.name,
                                              style: TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 1,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(widget.animal_Breed),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          widget.isMale
                                              ? FontAwesomeIcons.mars
                                              : FontAwesomeIcons.venus,
                                          size: 23,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          widget.isMale ? "Male" : "Female",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.clock,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          "${widget.age}" + " Years",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    if (isAdmin)
                                      IconButton(
                                        onPressed: () {
                                          if (currentUser.UserID ==
                                              selectedAnimal.createdBy) {
                                            showConfirmationDialog(
                                                context, widget.id);
                                          } else {
                                            showErrorDialog(context);
                                          }
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.trash,
                                          size: 20,
                                          color: Colors.red.shade900,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -15,
              top: -22,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      // spreadRadius: 1.0,
                      blurRadius: 6,
                      offset: Offset(0.0, 0.2),
                    ),
                  ],
                ),
                alignment: Alignment.bottomCenter,
                width: 190,
                height: 200,
                child: Image(
                  image: NetworkImage(widget.image),
                  height: 220.0,
                  fit: BoxFit.fitHeight,
                  width: deviceWidth * 0.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
