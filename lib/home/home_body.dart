import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../helpers/constants.dart';

class HomeBodyWidget extends StatefulWidget {
  const HomeBodyWidget({Key? key}) : super(key: key);

  @override
  _HomeBodyWidgetState createState() => _HomeBodyWidgetState();
}

class _HomeBodyWidgetState extends State<HomeBodyWidget> {
  bool _isLoadingData = true;
  double latitude = 0.0;
  double longitude = 0.0;

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

  _getUserPosition() async {
    try {
      setState(() {
        _isLoadingData = true;
      });
      var position = await _determinePosition();
      longitude = position.longitude;
      latitude = position.latitude;
    } catch (e) {
      showErrorDialog(e.toString());
    }
    setState(() {
      _isLoadingData = false;
    });
  }

  void showErrorDialog(String error) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1;
    Dialog dialog = Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 80,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              error,
              style: bodyText1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    showGeneralDialog(
      context: context,
      barrierLabel: "Emergency Error",
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getUserPosition();
    });
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
    _getUserPosition();
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var heading = themeData.textTheme.headline1;
    var bodyText2 = themeData.textTheme.bodyText2;
    return (_isLoadingData)
        ? const Center(child: CircularProgressIndicator.adaptive())
        : SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(latitude, longitude),
                      zoom: 13.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: kDefaultPadding / 2,
                      right: kDefaultPadding / 2,
                      top: kDefaultPadding / 2),
                  child: Text(
                    "Your Current Location",
                    style: heading!.copyWith(fontSize: 26),
                  ),
                ),
                const SizedBox(width: kDefaultMargin / 4),
                Padding(
                  padding: const EdgeInsets.only(
                      left: kDefaultPadding / 2,
                      right: kDefaultPadding / 2,
                      top: kDefaultPadding / 2),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: kDeepBlue,
                      ),
                      const SizedBox(width: kDefaultMargin / 5),
                      Text(
                        'Latitude:$latitude',
                        style: bodyText2,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: kDefaultMargin / 5),
                Padding(
                  padding: const EdgeInsets.only(
                      left: kDefaultPadding / 2,
                      right: kDefaultPadding / 2,
                      top: kDefaultPadding / 2),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: kDeepBlue,
                      ),
                      const SizedBox(width: kDefaultMargin / 5),
                      Text(
                        'Longitude:$longitude',
                        style: bodyText2,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: kDefaultMargin / 2),
              ],
            ),
          );
  }
}
