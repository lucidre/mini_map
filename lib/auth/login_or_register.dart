import 'package:flutter/material.dart';
import 'package:mini_map/auth/login.dart';
import 'package:mini_map/auth/register.dart';
import 'package:mini_map/helpers/page_route.dart';

import '../helpers/constants.dart';

class PickLoginOrSignUpScreen extends StatefulWidget {
  const PickLoginOrSignUpScreen({Key? key}) : super(key: key);

  @override
  _PickLoginOrSignUpScreenState createState() =>
      _PickLoginOrSignUpScreenState();
}

class _PickLoginOrSignUpScreenState extends State<PickLoginOrSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var heading = themeData.textTheme.headline1;
    var bodyText1 = themeData.textTheme.bodyText1;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Image.asset(
                logoLocation,
                height: 300,
                fit: BoxFit.cover,
                width: 300,
                //it is for the image
              ),
              const SizedBox(
                height: kDefaultMargin,
              ),
              Text(
                'Welcome to',
                style: bodyText1,
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
              const SizedBox(
                height: kDefaultMargin,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kDeepBlue,
                    elevation: 5,
                  ),
                  onPressed: login,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: kDefaultPadding / 2, bottom: kDefaultPadding / 2),
                    child: Text(
                      'Login',
                      style: bodyText1!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: kDeepBlue,
                      margin: const EdgeInsets.only(right: kDefaultMargin / 4),
                    ),
                  ),
                  Text(
                    'or',
                    style: bodyText1,
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: kDeepBlue,
                      margin: const EdgeInsets.only(left: kDefaultMargin / 4),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: register,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 2.0, color: kDeepBlue),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultPadding / 2),
                    child: Text(
                      'Register',
                      style: bodyText1,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void login() {
    Navigator.of(context).push(CustomPageRoute(screen: const LoginScreen()));
  }

  void register() {
    Navigator.of(context).push(
      CustomPageRoute(screen: const RegisterScreen()),
    );
  }
}
