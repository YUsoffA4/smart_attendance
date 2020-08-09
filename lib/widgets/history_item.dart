import 'package:flutter/material.dart';
import 'package:smart_attendance/res/asset_path.dart';
import 'package:smart_attendance/widgets/small_image.dart';


class HistoryItem extends StatelessWidget {
  final String section, date;

  HistoryItem({this.section, this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 28.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white.withAlpha(120),
        boxShadow: [BoxShadow(color: Colors.grey.withAlpha(150))]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              SmallImage(img: AssetPath.SCAN_IMAGE, mini: true,),
              SizedBox(width: 10.0),
              Text(section,style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0
              ),),
            ],
          ),

          Text(date,style: TextStyle(
              fontSize: 12.0
          ),),
        ],
      ),
    );
  }
}
