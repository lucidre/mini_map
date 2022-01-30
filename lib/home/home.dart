import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mini_map/auth/login_or_register.dart';
import 'package:mini_map/helpers/constants.dart';
import 'package:mini_map/helpers/firebase_util.dart';
import 'package:mini_map/helpers/page_route.dart';
import 'package:mini_map/home/bookmarks.dart';
import 'package:mini_map/home/home_body.dart';

import 'fab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: const HomeFloatingActionBar(),
      body: const Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        margin: EdgeInsets.all(kDefaultMargin),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: HomeBodyWidget(),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    var themeData = Theme.of(context);
    var heading = themeData.textTheme.headline1;

    return AppBar(
      title: RichText(
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textAlign: TextAlign.start,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Mini',
              style: heading!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 30),
            ),
            TextSpan(
              text: 'Map',
              style: heading.copyWith(fontSize: 30),
            ),
            TextSpan(
              text: '.',
              style: heading.copyWith(fontSize: 40),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(CustomPageRoute(screen: const BookmarkScreen()));
          },
          icon: const Icon(
            Icons.bookmark,
            color: kDeepBlue,
          ),
        ),
        IconButton(
          onPressed: () async {
            await GoogleSignIn().signOut();
            await sFirebaseAuth.signOut();

            Navigator.of(context).pushAndRemoveUntil(
                CustomPageRoute(screen: const PickLoginOrSignUpScreen()),
                (route) => false);
          },
          icon: const Icon(
            Icons.logout,
            color: kDeepBlue,
          ),
        ),
      ],
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }
}
