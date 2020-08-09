import 'package:flutter/material.dart';

class SmallImage extends StatelessWidget {
  final bool mini;
  final String img;
  SmallImage({@required this.img, this.mini = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: mini? 50.0 :70.0,
      height: mini? 50.0 :70.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          image: AssetImage(img),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}