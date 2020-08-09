import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:barcode_scan/barcode_scan.dart';

import '../models/formatted_time.dart';
import '../models/history.dart';

class AssetManager{

  static List<AttendanceHistory> reportData = List();
  static String reportDate = "";
  static String reportSection = "";
  ScanResult scanResult;

  static var _aspectTolerance = 0.00;
  static int _selectedCamera = -1;
  static bool _useAutoFocus = true;
  static bool _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  static List<BarcodeFormat> selectedFormats = _possibleFormats;


  static Future<String> scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": "Cancel",
          "flash_on": "Flash on",
          "flash_off": "Flash off",
        },
        restrictFormat: selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);
      return result.rawContent;
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        result.rawContent = 'ERROR: PERMISSION_DENIED';
      } else {
        result.rawContent = 'UNKNOWN ERROR $e';
      }
      return result.rawContent;
    }
  }

  static Future<void> alertDialog(BuildContext context, Widget content)async{
    return await showDialog(
        context: context,
        child: AlertDialog(
          elevation: 5.0,
          actions: <Widget>[
            RaisedButton(
              onPressed: () => Navigator.pop(context),
              elevation: 5,
              child: Text('OK', style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              color: Colors.blue.withOpacity(0.7),
            ),

          ],
          backgroundColor:Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          title: content,
        )
    );
  }

  static FormattedTime formattedDate(){
    final currentDate = DateTime.now();
    return FormattedTime(
      year: currentDate.year,
      month: currentDate.month,
      day: currentDate.day,
      time: "${currentDate.hour}:${currentDate.minute}"
    );
  }

  static Future<void> launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}