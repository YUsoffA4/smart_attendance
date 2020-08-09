import 'package:flutter/material.dart';
import 'package:smart_attendance/res/asset_path.dart';
import 'package:smart_attendance/widgets/small_image.dart';


class GeneralHistoryItem extends StatelessWidget {
  final String section, date, name, code;

  GeneralHistoryItem({this.section, this.date, this.name, this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white.withAlpha(120),
          boxShadow: [BoxShadow(color: Colors.grey.withAlpha(150))]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SmallImage(img: AssetPath.SCAN_IMAGE, mini: true,),
          SizedBox(width: 15.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("$name, $code",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0
              ),
              ),
              Text("section: $section\ndate: $date",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0
              ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
