import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_file/flutter_share_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';


class GenerateQR extends StatefulWidget {
  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  String message = "";
  GlobalKey _globalKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    final MQH = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.share),
        onPressed: ()async{
          await _capturePng();
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Generate QR Code'),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              SizedBox(height: MQH * 0.1),
              RepaintBoundary(
                key: _globalKey,
                child: Center(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(50.0),
                    child: CustomPaint(
                      size: Size.square(180.0),
                      painter: QrPainter(
                        gapless: true,
                        data: message,
                        version: QrVersions.auto,
                        color: Theme.of(context).primaryColor,
                        emptyColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MQH * 0.05),
              TextFormField(
                onChanged: (val){
                  setState(() {
                    message = val;
                  });
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                enableSuggestions: true,
                autocorrect: true,
                decoration: InputDecoration(
                  hintText: "Please enter the section name ...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                    contentPadding: const EdgeInsets.all(5)
                ),
              ),
              SizedBox(height: MQH * 0.05),
            ],
          ),
        ),
      ),
    );
  }


  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      Directory tempDir = await getTemporaryDirectory();
      print(tempDir.path);
      await _saveAndShareImage(pngBytes, tempDir, "QR.png");
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _saveAndShareImage(Uint8List uint8List, Directory dir, String fileName,
      {Function success, Function fail}) async {
    bool isDirExist = await Directory(dir.path).exists();
    if (!isDirExist) Directory(dir.path).create();
    String tempPath = '${dir.path}/$fileName';
    File image = File(tempPath);
    bool isExist = await image.exists();
    if (isExist) await image.delete();
    await File(tempPath).writeAsBytes(uint8List).then((_) async{
      await FlutterShareFile.shareImage(tempPath, 'QR.png');
    });
  }

}