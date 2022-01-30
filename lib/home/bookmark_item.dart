import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_map/helpers/constants.dart';
import 'package:mini_map/model/map.dart';

class BookmarkItem extends StatelessWidget {
  final MapModel mapModel;
  final Function(MapModel) function;

  const BookmarkItem({
    Key? key,
    required this.mapModel,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context).textTheme;
    var textTheme = themeData.bodyText1;
    var textStyle2 = themeData.bodyText2;

    const radius = BorderRadius.all(Radius.circular(5));
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.all(kDefaultMargin / 4),
      elevation: 3,
      child: InkWell(
        borderRadius: radius,
        splashColor: kPrimaryColor.shade100,
        onTap: () => function(mapModel),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mapModel.title,
                style: textTheme!
                    .copyWith(color: kDeepBlue, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: kDefaultMargin / 4,
              ),
              Row(
                children: [
                  const Icon(Icons.date_range, color: Colors.black),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    getFormattedDate(mapModel.date),
                    style: textStyle2,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String getFormattedDate(String timestamp) {
    try {
      var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (exception) {
      return "";
    }
  }
}
