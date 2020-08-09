import 'package:flutter/material.dart';
import 'package:smart_attendance/res/asset_path.dart';
import 'package:smart_attendance/widgets/about_image.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("About"),
      ),
      body: _aboutStudentsBuilder(context),
    );
  }


  Widget _aboutStudentsBuilder(BuildContext context) {
    final double MQW = MediaQuery.of(context).size.width;
    final double MQH = MediaQuery.of(context).size.height;
    return Container(
      width: MQW,
      height: MQH,
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, bottom: 15.0, top: 0.0),
          width: MQW * 0.93,
          height: MQH * 0.81,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [BoxShadow(color: Colors.white.withAlpha(170))]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          AboutImage(
                            img: AssetPath.UNIVERSITY_LOGO,
                            mini: true,
                          ),
                          Flexible(
                            child: Text(AssetPath.ABOUT_FACULTY,
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    height: 1.3,
                                    fontWeight: FontWeight.bold,
                                    fontSize: MQW * 0.02 + 4.0)),
                          ),
                          AboutImage(img: AssetPath.FACULTY_LOGO, mini: true),
                        ],
                      ),
                      Divider(height: 5.0),
                      SizedBox(height: MQH * 0.05 + 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                AboutImage(
                                  img: AssetPath.STUDENT1_IMAGE,
                                ),
                                Text(
                                  AssetPath.STUDENT1_NAME,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                AboutImage(img: AssetPath.STUDENT2_IMAGE),
                                Text(
                                  AssetPath.STUDENT2_NAME,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: MQH * 0.03 + 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                AboutImage(
                                  img: AssetPath.STUDENT3_IMAGE,
                                ),
                                Text(
                                  AssetPath.STUDENT3_NAME,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                AboutImage(
                                  img: AssetPath.STUDENT4_IMAGE,
                                ),
                                Text(
                                  AssetPath.STUDENT4_NAME,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: MQH * 0.03 + 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                AboutImage(
                                  img: AssetPath.STUDENT5_IMAGE,
                                ),
                                Text(
                                  AssetPath.STUDENT5_NAME,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                AboutImage(
                                  img: AssetPath.STUDENT6_IMAGE,
                                ),
                                Text(
                                  AssetPath.STUDENT6_NAME,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: MQH * 0.03 + 10.0),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
