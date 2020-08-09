
import 'package:flutter/foundation.dart';

class Organization{
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final bool validateStudentLocation;
  final List<dynamic> sections;

  Organization({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.latitude,
    @required this.longitude,
    @required this.validateStudentLocation,
    @required this.sections,
  });
}