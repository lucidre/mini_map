import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mini_map/model/map.dart';

import '../helpers/constants.dart';
import '../helpers/firebase_util.dart';
import 'bookmark_item.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  bool _isLoading = false;
  List<MapModel> _bookmarkList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  //METHOD TO GET THE INITIAL DATA FROM FIREBASE
  void getData() async {
    setState(() {
      _isLoading = true; // activate loading progress bar while fetching data
    });

    try {
      var userId = (sFirebaseAuth.currentUser?.uid) ?? "";

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await sFirebaseCloud
          .collection('locations')
          .doc(userId)
          .collection(userId)
          .orderBy('date', descending: true)
          .get();

      setState(() {
        _isLoading = false;
        if (querySnapshot.docs.isNotEmpty) {
          var imageItem = getMappedList(querySnapshot);
          _bookmarkList = (imageItem == null) ? [] : imageItem;
        }
      });
    } catch (exception) {
      showErrorSnackBar(exception);
      setState(() {
        _isLoading = false;
        _bookmarkList = [];
      });
    }
  }

  void showErrorSnackBar(Object exception) {
    final snackBar = SnackBar(content: Text(exception.toString()));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //METHOD TO MAP FIREBASE DATA TO THE  MODEL
  List<MapModel>? getMappedList(QuerySnapshot? querySnapshot) {
    return querySnapshot?.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      return MapModel(
        title: data['title'],
        lat: data['lat'] ?? 0,
        long: data['long'] ?? 0,
        date: data['date'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var heading = themeData.textTheme.headline1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarks',
          style: heading!.copyWith(fontSize: 30),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: kDeepBlue,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: (_isLoading)
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView.builder(
              itemCount: _bookmarkList.length,
              itemBuilder: (ctx, index) {
                return BookmarkItem(
                    mapModel: _bookmarkList[index],
                    function: onMapModelClicked);
              },
            ),
    );
  }

  onMapModelClicked(MapModel mapModel) {
    var themeData = Theme.of(context);
    var heading = themeData.textTheme.headline1;
    var bodyText2 = themeData.textTheme.bodyText2;

    Dialog dialog = Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 5,
      child: Container(
        width: 400,
        height: 600,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(mapModel.lat, mapModel.long),
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
                mapModel.title,
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
                    'Latitude:${mapModel.lat}',
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
                    'Longitude:${mapModel.long}',
                    style: bodyText2,
                  )
                ],
              ),
            ),
            const SizedBox(width: kDefaultMargin / 2),
          ],
        ),
      ),
    );
    showGeneralDialog(
      context: context,
      barrierLabel: "Location Dialog",
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
}
