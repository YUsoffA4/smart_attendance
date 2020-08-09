import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../prefs/pref_keys.dart';
import '../prefs/pref_util.dart';

class PrefManager {
  static String userName;
  static String userCode;
  static LatLng current_location;
  static String orgId;
  static String orgName;
  static String orgDescription;
  static double orgLat;
  static double orgLng;
  static bool validateStudentLocation;
  static String orgAddress;
  static List<String> orgSections;


  static Future<bool> initializeOrganizationData()async{
    userName = await getUserName();
    userCode = await getUserCode();
    orgId   = await getOrgId();
    validateStudentLocation = await getValidateStudentLocation();

    orgName         = await getOrgName();
    orgDescription  = await getOrgDeanName();
    orgLat          = await getOrgLatitude();
    orgLng          = await getOrgLongitude();
    orgSections     = await getOrgSections();
    orgAddress      = await getOrgAddressFromCoordinates()?await getOrgAddress():"No Address";
    if(await getUserLatitude() != null)
      current_location = LatLng(await getUserLatitude(), await getUserLongitude());
    else{
      await getUserLocation();
    }
    return true;
  }

  static Future<void> setOrganizationData({String id, String name, String description, double lat, double lng, bool validate, List<String> sections})async{
    orgId = id != null? id : orgId;
    orgName = name != null? name : orgName;
    orgDescription = description != null? description : orgDescription;
    orgLat = lat != null? lat : orgLat;
    orgLng = lng != null? lng : orgLng;
    validateStudentLocation = validate;
    orgSections = sections != null? sections : orgSections;
    orgAddress = await getOrgAddressFromCoordinates()?await getOrgAddress():"No Address";
    await _setOrgData();
  }

  static Future<void> _setOrgData()async{
    await setOrgId(orgId);
    await setOrgName(orgName);
    await setOrgDeanName(orgDescription);
    await setOrgLatitude(orgLat);
    await setOrgLongitude(orgLng);
    await setOrgSections(orgSections);
    await setOrgAddress(orgAddress);
    await setValidateStudentLocation(validateStudentLocation);
  }




  static Future<void> setOrgId(String id) async {
    await PrefUtils.setString(PrefKeys.ORG_ID, id);
  }

  static Future<String> getOrgId() async {
    return await PrefUtils.getString(PrefKeys.ORG_ID);
  }

  static Future<void> setOrgName(String name) async {
    await PrefUtils.setString(PrefKeys.ORG_NAME, name);
  }

  static Future<String> getOrgName() async {
    return await PrefUtils.getString(PrefKeys.ORG_NAME);
  }

  static Future<void> setOrgSections(List<String> name) async {
    await PrefUtils.setStringList(PrefKeys.ORG_LIST, name);
  }

  static Future<List<String>> getOrgSections() async {
    return await PrefUtils.getStringList(PrefKeys.ORG_LIST);
  }

  static Future<void> setOrgDeanName(String name) async {
    await PrefUtils.setString(PrefKeys.ORG_DEAN, name);
  }

  static Future<String> getOrgDeanName() async {
    return await PrefUtils.getString(PrefKeys.ORG_DEAN);
  }

  static Future<String> getUserName() async {
    return await PrefUtils.getString(PrefKeys.USER_NAME);
  }

  static Future<void> setUserName(String name) async {
    userName = name;
    await PrefUtils.setString(PrefKeys.USER_NAME, name);
  }

  static Future<String> getUserCode() async {
    return await PrefUtils.getString(PrefKeys.USER_CODE);
  }

  static Future<void> setUserCode(String code) async {
    userCode = code;
    await PrefUtils.setString(PrefKeys.USER_CODE, code);
  }

  static Future<void> setOrgAddress(String address) async {
    await PrefUtils.setString(PrefKeys.ORG_ADDRESS, address);
  }

  static Future<String> getOrgAddress() async {
    return await PrefUtils.getString(PrefKeys.ORG_ADDRESS);
  }

  static Future<void> setValidateStudentLocation(bool val) async {
    await PrefUtils.setBool(PrefKeys.VALIDATE_STUDENT_LOCATION, val);
  }

  static Future<bool> getValidateStudentLocation() async {
    return await PrefUtils.getBool(PrefKeys.VALIDATE_STUDENT_LOCATION);
  }

  static Future<void> setOrgLatitude(double lat) async {
    await PrefUtils.setDouble(PrefKeys.ORG_LAT, lat);
  }

  static Future<double> getOrgLatitude() async {
    return await PrefUtils.getDouble(PrefKeys.ORG_LAT);
  }

  static Future<void> setOrgLongitude(double lng) async {
    await PrefUtils.setDouble(PrefKeys.ORG_LNG, lng);
  }

  static Future<double> getOrgLongitude() async {
    return await PrefUtils.getDouble(PrefKeys.ORG_LNG);
  }

  static Future<void> setUserLatitude(double lat) async {
    await PrefUtils.setDouble(PrefKeys.USER_LAT, lat);
  }

  static Future<double> getUserLatitude() async {
    return await PrefUtils.getDouble(PrefKeys.USER_LAT);
  }

  static Future<void> setUserLongitude(double lng) async {
    await PrefUtils.setDouble(PrefKeys.USER_LNG, lng);
  }

  static Future<double> getUserLongitude() async {
    return await PrefUtils.getDouble(PrefKeys.USER_LNG);
  }

  static Future<void> clearAllData() async {
    await PrefUtils.clearData();
  }

  static Future<bool> getUserLocation() async {
    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();

    LocationData myLocation;
    String error;
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    Location location = Location();

    _serviceEnabled = await location.requestService();

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("LOCATION_NOT_GRANTED !!!!!");
        return false;
      }
    }
    try {
      if(await checkInternetConnectivity()) {
        myLocation = await location.getLocation();
        current_location = LatLng(myLocation.latitude, myLocation.longitude);
        setUserLatitude(myLocation.latitude);
        setUserLongitude(myLocation.longitude);
      }else{
        return false;
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
      return false;
    }catch(e){
      print("ERROR");
    }
    return true;
  }

  static Future<bool> getOrgAddressFromCoordinates()async{
    Coordinates coordinates = Coordinates(orgLat, orgLng);
    List<Address> addresses;
    try {
      addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    }catch(e){
      print('Can\'t get location');
      return false;
    }
    var first = addresses.first;
    await setOrgAddress(first.locality + ', ' + first.countryName);
    return true;
  }


  static Future<bool> checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    } else if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      return true;
    }
  }

  static Future<bool> isInOrganization()async{
    double distanceInMeters = await Geolocator().distanceBetween(
        current_location.latitude,
        current_location.longitude,
        orgLat,
        orgLng
    );
    return distanceInMeters <= 80.0? true : false;
  }
}
