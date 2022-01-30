import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_map/helpers/constants.dart';
import 'package:mini_map/splash/splash_screen.dart';

import 'helpers/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: kPrimaryColor,
        backgroundColor: kBackgroundColor,
        fontFamily: poppings,
        textTheme: Theme.of(context).textTheme.copyWith(
              bodyText1:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
              bodyText2:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              headline1: const TextStyle(
                fontWeight: FontWeight.bold,
                color: kDeepBlue,
                fontSize: 60,
              ),
            ),
      ),
      home: const SplashScreen(),
    );
  }
}
