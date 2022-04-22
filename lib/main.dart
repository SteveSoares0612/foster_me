import 'package:flutter/material.dart';
import 'package:foster_me/screens/profile_screen.dart';
import './models/animals.dart';
import './models/authentication.dart';
import './screens/cms.dart';
import './screens/petBreedFinder_screen.dart';
import './screens/signup.dart';
import './widgets/petView.dart';
import './screens/menu_screen.dart';
import './screens/MainFoster_screen.dart';
import './screens/petDetails_screen.dart';
import './screens/login.dart';
import 'package:provider/provider.dart';
import './screens/splash_screen.dart';
import './screens/menuFrame.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

Color firstColor = Color.fromRGBO(48, 96, 53, 1.0);
Color secondColor = Color.fromRGBO(40, 123, 33, 1.0);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Main_Foster()),
        ChangeNotifierProvider.value(value: petView()),
        //Get the authenticated user token from autehntication class and send it to animals class to access products only if signed in
        ChangeNotifierProxyProvider2<Auth, petView, Animals>(
          update: (ctx, authData, category, previousAnimals) => Animals(
            authData.token,
            category.getChosenCategory,
            previousAnimals == null ? [] : previousAnimals.animals,
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          title: "Foster Me",
          theme: ThemeData(
            fontFamily: 'Poppins',
            primaryColor: Color.fromRGBO(27, 124, 16, 1),
            //Color.fromRGBO(255, 211, 211, 1),
          ),
          home: authData.auth ? MenuFrame(authData.isAdmin) : Login(),
          routes: {
            // // '/': (ctx) => Main_Foster(),
            // '/': (ctx) => Login(),
            MenuScreen.routeName: (ctx) => MenuScreen(),
            PetDetailsScreen.routeName: (ctx) => PetDetailsScreen(),
            Main_Foster.routeName: (ctx) => Main_Foster(),
            Login.routeName: (ctx) => Login(),
            Signup.routeName: (ctx) => Signup(),
            CMS.routeName: (ctx) => CMS(),
            DetermineBreed.routeName: (ctx) => DetermineBreed(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
          },
        ),
      ),
    );
  }
}
