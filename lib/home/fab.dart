import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mini_map/helpers/constants.dart';

import '../helpers/firebase_util.dart';

class HomeFloatingActionBar extends StatelessWidget {
  const HomeFloatingActionBar({
    Key? key,
  }) : super(key: key);

  // get user latitude and longitude
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled. Kindly enable it');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions needed to send emergency');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions. Kingly enable it in settings');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // isExtended: true,
      child: const Icon(Icons.save),
      backgroundColor: kPrimaryColor,
      onPressed: () => showSaveDialog(context),
    );
  }

  //INITIAL DIALOG
  void showSaveDialog(BuildContext context) {
    var themeData = Theme.of(context).textTheme;
    var textTheme = themeData.bodyText1;
    var textStyle2 = themeData.bodyText2;

    Dialog dialog = Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 5,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              alignment: Alignment.center,
              width: 280,
              decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: const Icon(
                Icons.save,
                color: Colors.white,
                size: 100,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Do you want to save your current location?',
              style: textTheme,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kDeepBlue,
                  elevation: 5,
                ),
                onPressed: () {
                  var navigatorState = Navigator.of(context);
                  navigatorState.pop();
                  showUploadDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    'Save',
                    style: textStyle2!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: kDefaultMargin / 4,
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue, width: 2),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    side: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                onPressed: () {
                  var navigatorState = Navigator.of(context);
                  navigatorState.pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    'Cancel',
                    style: textStyle2.copyWith(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showGeneralDialog(
      context: context,
      barrierLabel: "Pick Document",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => dialog,
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(anim),
        child: child,
      ),
    );
  }

  //add location title
  void showUploadDialog(BuildContext context) async {
    String title = "";
    var themeData = Theme.of(context).textTheme;
    var textTheme = themeData.bodyText1;
    var textStyle2 = themeData.bodyText2;

    Dialog dialog = Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 5,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              alignment: Alignment.center,
              width: 280,
              decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: const Icon(
                Icons.cloud_upload,
                color: Colors.white,
                size: 100,
              ),
            ),
            const SizedBox(
              height: kDefaultMargin / 2,
            ),
            Text(
              'Please enter a tag for your current location',
              style: textTheme,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: kDefaultMargin,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                'Title',
                style: textTheme!
                    .copyWith(fontWeight: FontWeight.bold, color: kDeepBlue),
              ),
            ),
            TextField(
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: "Please enter a title",
              ),
              style: textTheme.copyWith(fontSize: 18),
              onChanged: (value) {
                title = value;
              },
            ),
            const SizedBox(
              height: kDefaultMargin / 2,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kDeepBlue,
                  elevation: 5,
                ),
                onPressed: () async {
                  if (title.isNotEmpty) {
                    try {
                      var position = await _determinePosition();
                      double longitude = position.longitude;
                      double latitude = position.latitude;
                      uploadDocument(
                          lat: latitude,
                          long: longitude,
                          title: title,
                          context: context);
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a title')));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    'Save',
                    style: textStyle2!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showGeneralDialog(
      context: context,
      barrierLabel: "Upload Location",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => dialog,
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(anim),
        child: child,
      ),
    );
  }

  void uploadDocument(
      {required double lat,
      required double long,
      required String title,
      required BuildContext context}) async {
    try {
      var userId = (sFirebaseAuth.currentUser?.uid) ?? "";
      var dateTime = DateTime.now().millisecondsSinceEpoch;

      await sFirebaseCloud
          .collection('locations')
          .doc(userId)
          .collection(userId)
          .add({
        'lat': lat,
        'long': long,
        'title': title,
        'date': dateTime.toString(),
      });
      showSnackBar('Upload Successful', context);
    } catch (e) {
      showErrorSnackBar(context, e);
    }
    Navigator.of(context).pop();
  }

  void showErrorSnackBar(BuildContext context, Object exception) {
    final snackBar = SnackBar(content: Text(exception.toString()));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
