
import 'package:flutter/cupertino.dart';

class AttendanceHistory{
  final String org;
  final String sectionId;
  final String userId;
  final String userName;
  final String code;
  final String time;
  final int year, month, day;

  AttendanceHistory({
    @required this.userId,
    @required this.userName,
    @required this.code,
    @required this.sectionId,
    @required this.year,
    @required this.month,
    @required this.day,
    @required this.time,
    this.org,
  });

  @override
  String toString() {

    return "id: $userId\nname: $userName\nSection: $sectionId\nDateTime: $time $day/$month/$year\n";
  }
}