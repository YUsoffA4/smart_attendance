
import 'package:flutter/cupertino.dart';

class User{
  final String name;
  final String code;
  final String orgId;
  final bool isAdmin;
  final bool isGranted;

  const User({
    @required this.name,
    @required this.code,
    @required this.orgId,
    @required this.isAdmin,
    @required this.isGranted,
  });

}