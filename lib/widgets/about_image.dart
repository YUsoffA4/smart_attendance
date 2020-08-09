import 'package:flutter/material.dart';

class AboutImage extends StatelessWidget {
  final bool mini;
  final String img;
  final BoxFit boxFit;
  AboutImage({@required this.img, this.mini = false, this.boxFit = BoxFit.fill});
  @override
  Widget build(BuildContext context) {
    final double MQW = MediaQuery.of(context).size.width;
    final double MQH = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      width: mini? MQW * 0.08 + 10.0 :MQW * 0.19 + 10.0,
      height: mini? MQW * 0.08 + 10.0 :MQW * 0.19 + 10.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          image: AssetImage(img),
          fit: boxFit,
        ),
      ),
    );
  }
}