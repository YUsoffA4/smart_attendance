import 'package:flutter/material.dart';

class MainIcon extends StatelessWidget {
  Function onTab;
  final String image, title;

  MainIcon({this.title, this.image, this.onTab});

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => onTab(),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.fill
                )
            ),
          ),
        ),
        Flexible(child: Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.withOpacity(0.9), fontSize: 16),))
      ],
    );
  }
}
