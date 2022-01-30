import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_map/auth/login_or_register.dart';
import 'package:mini_map/helpers/constants.dart';
import 'package:mini_map/helpers/firebase_util.dart';
import 'package:mini_map/helpers/page_route.dart';
import 'package:mini_map/home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var heading = Theme.of(context).textTheme.headline1;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              logoLocation,
              height: 300,
              width: 300,
              fit: BoxFit.cover,
              //it is for the image
            ),
            const SizedBox(
              height: kDefaultMargin / 5,
            ),
            RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textAlign: TextAlign.start,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Mini',
                    style: heading!.copyWith(
                        fontWeight: FontWeight.normal, color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Map',
                    style: heading,
                  ),
                  TextSpan(
                    text: '.',
                    style: heading.copyWith(fontSize: 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  Future startTime() async {
    return Timer(const Duration(milliseconds: 5000), navigatePage);
  }

  void navigatePage() {
    bool isUserLoggedIn = sFirebaseAuth.currentUser != null;
    Navigator.of(context).pushReplacement(CustomPageRoute(
        screen: isUserLoggedIn
            ? const HomeScreen()
            : const PickLoginOrSignUpScreen()));
  }
}
