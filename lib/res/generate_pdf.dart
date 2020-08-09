import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/history.dart';
import '../res/asset_manager.dart';


Future<Uint8List> generateDocument(PdfPageFormat format) async {
  final pw.Document doc = pw.Document();
  double header1Size = 24;
  double header2Size = 20;
  double header3Size = 18;

  List<AttendanceHistory> data = AssetManager.reportData;
  String date = AssetManager.reportDate;
  String section = AssetManager.reportSection;
  List<List<String>> output = List();
  output.add(['Name', 'Code']);
  for(int i = 0 ; i < data.length ; i++){
    output.add([data[i].userName,data[i].code]);
  }

  doc.addPage(
      pw.MultiPage(
          pageFormat:
          PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          header: (pw.Context context) {

            return pw.Container(
                alignment: pw.Alignment.centerLeft,
                margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                decoration: const pw.BoxDecoration(
                    border: pw.BoxBorder(
                        bottom: true, width: 0.5, color: PdfColors.grey)),
                child: pw.Text('Smart Attendance Report',
                    style: pw.Theme.of(context)
                        .defaultTextStyle
                        .copyWith(color: PdfColors.grey))
            );
          },
          footer: (pw.Context context) {
            return pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                child: pw.Text(
                    'Page ${context.pageNumber} of ${context.pagesCount}',
                    style: pw.Theme.of(context)
                        .defaultTextStyle
                        .copyWith(color: PdfColors.grey)));
          },
          build: (pw.Context context) => <pw.Widget>[
            pw.Header(
                level: 0,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: <pw.Widget>[
                      pw.Text('Attendance Report', textScaleFactor: 1, style: pw.TextStyle(fontSize: header1Size)),
                    ])),

            pw.Text(date == ""?" " : "Date: " + date, style: pw.TextStyle(fontSize: header2Size)),
            pw.Text(section == ""?" " : "Section: " + section, style: pw.TextStyle(fontSize: header2Size)),
            pw.Text(" \n"),
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(fontSize: header3Size, fontWeight: pw.FontWeight.bold),
              cellStyle: pw.TextStyle(fontSize: header3Size),
                context: context,
                data: output),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
          ]));

  return doc.save();
}