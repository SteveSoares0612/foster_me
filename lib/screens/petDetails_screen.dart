import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foster_me/models/authentication.dart';
import 'package:foster_me/models/fosterApplication.dart';
import 'package:foster_me/screens/MainFoster_screen.dart';
import '../models/animals.dart';
import 'package:provider/provider.dart';
import '../models/users.dart';
import '../models/animal.dart';

class PetDetailsScreen extends StatefulWidget {
  static const routeName = '/petDetails';

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  List<User> userDetails;
  var _isloading = false;
  var _isInit = true; //Set loader'
  String animalID;
  Animal selectedAnimal;
  User creatorInfo;
  Future<void> future;
  bool eligible = false;
  String ButtonText = "Check Eligibility";
  Icon icon = Icon(Icons.info, color: Colors.black);

  @override
  int score = 0;
  void initState() {
    future = Provider.of<Auth>(context, listen: false).getAllUsers();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    animalID = ModalRoute.of(context).settings.arguments as String;
    userDetails = Provider.of<Auth>(
      context,
      listen: false,
    ).users;
    selectedAnimal = Provider.of<Animals>(
      context,
      listen: false,
    ).findById(animalID);
    super.didChangeDependencies();
  }

  void checkEligibility(List<User> user, Animal selectedAnimal) {
    score = 0;
    if (score >= 0) {
      if ((selectedAnimal.isMale &&
              (user[0].selectedGender == "Male" ||
                  user[0].selectedGender == "Any")) ||
          (!selectedAnimal.isMale &&
              (user[0].selectedGender == "Female" ||
                  user[0].selectedGender == "Any"))) {
        score += 5;
      }
      if ((selectedAnimal.size == "Small" &&
              (user[0].selectedSize == "Small" ||
                  user[0].selectedSize == "Any")) ||
          (selectedAnimal.size == "Medium" &&
              (user[0].selectedSize == "Medium" ||
                  user[0].selectedSize == "Any")) ||
          (selectedAnimal.size == "Large" &&
              (user[0].selectedSize == "Large" ||
                  user[0].selectedSize == "Any"))) {
        score += 5;
      }
      if ((selectedAnimal.activityLevel.contains("Busy") &&
              user[0].selectedactivityLevel.contains("Busy")) ||
          (selectedAnimal.activityLevel.contains("Moderate") &&
              user[0].selectedactivityLevel.contains("Moderate")) ||
          (selectedAnimal.activityLevel.contains("Quite") &&
              user[0].selectedactivityLevel.contains("Quite"))) {
        score += 5;
      }
      if ((selectedAnimal.goodWithKids && user[0].hasKids == "true") ||
          (!selectedAnimal.goodWithKids && user[0].hasKids == "false")) {
        score += 5;
      }
      if ((selectedAnimal.size == "Small") ||
          (selectedAnimal.size == "Medium" &&
              (user[0].selectedHouseType != "Apartment" ||
                  user[0].selectedHouseType != "Hotel")) ||
          (selectedAnimal.size == "Large" &&
              (user[0].selectedSize != "Apartment" ||
                  user[0].selectedSize != "Hotel" ||
                  user[0].selectedSize != "Townhouse"))) {
        score += 5;
      }
      if ((selectedAnimal.healthStatus.contains("Healthy")) ||
          (user[0].willingTotakeToVet == "true") ||
          (selectedAnimal.healthStatus == "Moderate" &&
              user[0].willingTotakeToVet == "true") ||
          (selectedAnimal.healthStatus == "Poor" &&
              user[0].willingTotakeToVet == "true")) {
        score += 5;
      } else {
        score -= 5;
      }
    }
    if (score >= 0 && score < 20) {
      print("Not eligibile");
      setState(() {
        eligible = false;
      });
      print(score);
    } else {
      print("Eligible");
      setState(() {
        eligible = true;
      });
      print(score);
    }
  }

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

  Widget buildDetailsList(BuildContext context, String title, String value) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      width: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11.0),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.white,
            ]),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: new Offset(0.0, 1.0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 14, color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> applyToFoster(
      List<User> user, Animal selectedAnimal, BuildContext context) async {
    var _UserApplication = FApplication(
        animalid: selectedAnimal.id,
        animalcategory: selectedAnimal.category,
        Animalname: selectedAnimal.name,
        animal_Breed: selectedAnimal.animal_Breed,
        animalcreatedBy: selectedAnimal.createdBy,
        animalisMale: selectedAnimal.isMale,
        UserID: user[0].UserID,
        Address: user[0].Address,
        City: user[0].City,
        Country: user[0].Country,
        Email: user[0].Email,
        age: user[0].age,
        agreeForfoster: user[0].agreeForfoster,
        allergies: user[0].allergies,
        description: user[0].description,
        driver: user[0].driver,
        fullName: user[0].fullName,
        hasKids: user[0].hasKids,
        householdPeoplelist: user[0].householdPeoplelist,
        noOffamilyMembers: user[0].noOffamilyMembers,
        phoneNo: user[0].phoneNo,
        phoneNoWrk: user[0].phoneNoWrk,
        selectedGender: user[0].selectedGender,
        selectedHouseOcc: user[0].selectedHouseOcc,
        selectedHouseType: user[0].selectedHouseType,
        selectedSize: user[0].selectedSize,
        selectedactivityLevel: user[0].selectedactivityLevel,
        willingToTrain: user[0].willingToTrain,
        willingTotakeToVet: user[0].willingTotakeToVet);

    await Provider.of<Auth>(context, listen: false)
        .addApplication(_UserApplication)
        .then((value) => showApplicationSuccess(context))
        .then((value) => Navigator.pop(context));
  }

  showFailureDialog(BuildContext context) {
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
        "Oops",
        style: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700),
      ),
      content: Text("You are not eligible to foster this pet!  :("),
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

  showApplicationDialog(
      BuildContext ctx, List<User> user, Animal selectedAnimal) {
    Widget ApplyButton = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
      onPressed: () {
        applyToFoster(user, selectedAnimal, ctx);
      },
      child: Text(
        "Apply",
        style: TextStyle(color: Colors.white),
      ),
    );

    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
      onPressed: () => Navigator.pop(context),
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.white),
      ),
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Confirmation",
        style: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700),
      ),
      content: Text("Are you sure you want to apply to foster this pet?"),
      actions: [cancelButton, ApplyButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showApplicationSuccess(BuildContext context) {
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
        "Great!",
        style: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700),
      ),
      content: Text(
          "Your application has been sent! The shelter will contact you with further details and processes!"),
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

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
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
                    child: Image(
                      image: NetworkImage(selectedAnimal.Image),
                    ),
                  ),
                  Positioned(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                      child: InkWell(
                        onTap: () =>
                            {Navigator.of(context).pop(Main_Foster.routeName)},
                        child: Container(
                          width: 70,
                          child: Row(
                            children: [
                              Icon(
                                Icons.chevron_left,
                                size: 24,
                              ),
                              Text("Back")
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
                child: AppBar(
                  backgroundColor: Colors.white,
                  // Theme.of(context).primaryColor.withOpacity(0.9),
                  bottom: TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Tab(
                            icon: Icon(
                              Icons.info_outline,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            "Pet",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Tab(
                              icon: Icon(
                            Icons.gite_outlined,
                            color: Theme.of(context).primaryColor,
                          )),
                          Text(
                            "Shelter",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15, left: 15.0),
                                  child: Text(
                                    selectedAnimal.name,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15, right: 10.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white, elevation: 0),
                                    onPressed: () {
                                      checkEligibility(
                                          userDetails, selectedAnimal);

                                      if (eligible) {
                                        setState(() {
                                          ButtonText = "Eligible";
                                          icon = Icon(
                                            Icons.check,
                                            color: Colors.black,
                                          );
                                        });
                                      } else {
                                        setState(() {
                                          ButtonText = "Not Eligible";
                                          icon = Icon(Icons.close,
                                              color: Colors.black);
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          icon,
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            ButtonText,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                      // color: Colors.grey,
                                      ),
                                  child: ListView(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      buildDetailsList(
                                          context,
                                          "Sex",
                                          selectedAnimal.isMale
                                              ? "Male"
                                              : "Female"),
                                      buildDetailsList(context, "Age",
                                          '${(selectedAnimal.age)}' + " Years"),
                                      buildDetailsList(context, "Breed",
                                          selectedAnimal.animal_Breed),
                                      buildDetailsList(
                                          context, "Size", selectedAnimal.size),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        width: 140,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(11.0),
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white,
                                                Colors.white,
                                              ]),
                                          boxShadow: <BoxShadow>[
                                            new BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4.0,
                                              offset: new Offset(0.0, 1.0),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    "Scientific Name",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    selectedAnimal
                                                        .Scientific_Name,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      buildDetailsList(
                                          context,
                                          "Vaccinated",
                                          selectedAnimal.isVacinnated
                                              ? "Yes"
                                              : "No"),
                                      buildDetailsList(context, "Health Status",
                                          selectedAnimal.healthStatus),
                                      buildDetailsList(context, "Neutered",
                                          selectedAnimal.Spayed ? "Yes" : "No"),
                                      buildDetailsList(
                                          context,
                                          "Good With Kids?",
                                          selectedAnimal.goodWithKids
                                              ? "Yes"
                                              : "No"),
                                      buildDetailsList(
                                          context,
                                          "Good With Family?",
                                          selectedAnimal.goodWithLargeFamilies
                                              ? "Yes"
                                              : "No"),
                                      buildDetailsList(
                                          context,
                                          "Needs Training?",
                                          selectedAnimal.needsTraining
                                              ? "Yes"
                                              : "No"),
                                      buildDetailsList(
                                          context,
                                          "Prefered Household",
                                          selectedAnimal.activityLevel ==
                                                  "Busy/Moderate"
                                              ? "Any"
                                              : "Quite"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            buildTitle("Description"),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 15.0, bottom: 15, right: 15),
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  selectedAnimal.description,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w100,
                                      color: Colors.grey[600]),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {
                                        if (eligible) {
                                          showApplicationDialog(context,
                                              userDetails, selectedAnimal);
                                        } else {
                                          showFailureDialog(context);
                                        }
                                      },
                                      child: Material(
                                        borderRadius: BorderRadius.circular(18),
                                        elevation: 4,
                                        color: Theme.of(context).primaryColor,
                                        child: Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Container(
                                            width: 250,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Apply to Foster",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 19),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: future,
                      builder: (context, snapshotData) {
                        creatorInfo = Provider.of<Auth>(
                          context,
                          listen: false,
                        ).findUserById(selectedAnimal.createdBy);
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              buildTitle("Shelter Name"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 75,
                                      width: 325,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(11.0),
                                        color: const Color(0xffefefef),
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.white,
                                              Colors.white,
                                            ]),
                                        boxShadow: <BoxShadow>[
                                          new BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4.0,
                                            offset: new Offset(0.0, 1.0),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  child: CircleAvatar(
                                                    radius: 24.0,
                                                    backgroundImage:
                                                        NetworkImage(creatorInfo
                                                            .profileImage),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  creatorInfo.fullName,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black
                                                          .withOpacity(0.7)),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      creatorInfo.Email,
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              buildTitle("Shelter Description"),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 15.0, bottom: 15, right: 15),
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    creatorInfo.description,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.grey[600]),
                                  ),
                                ),
                              ),
                              buildTitle("Address"),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 15.0, bottom: 10, right: 15),
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    creatorInfo.Address +
                                        ", " +
                                        creatorInfo.City +
                                        ", " +
                                        creatorInfo.Country,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.grey[600]),
                                  ),
                                ),
                              ),
                              buildTitle("Location"),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 200,
                                        width: 340,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                "assets/Images/map.jpg"),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: const Color(0xffefefef),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0x29000000),
                                              offset: Offset(0, 3),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
