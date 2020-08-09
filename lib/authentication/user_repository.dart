import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/history.dart';
import '../models/organization.dart';
import '../prefs/pref_manager.dart';

import '../models/user.dart';

class UserRepository {
  final String uid;
  final FirebaseAuth _firebaseAuth;

  UserRepository({FirebaseAuth firebaseAuth, this.uid})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
  }


  final CollectionReference organizationCollection =
  Firestore.instance.collection('orgs');

  Future setUserData({String name, String code, String orgId, bool isAdmin}) async {
    CollectionReference userCollection = organizationCollection.document(orgId).collection('users');
    return await userCollection.document(await getUser()).setData({
      'name'     :      name,
      'code'     :      code,
      'orgId'    :     orgId,
      'isAdmin'  :   isAdmin,
      'isGranted':     false
    });
  }

  Future setUserHistory({String name, String code,int day, int month, int year, String time, String sectionId}) async {
    CollectionReference historyCollection = organizationCollection.document(PrefManager.orgId).collection('history');
    return await historyCollection.document().setData({
      'userName'  : name,
      'userId'    : uid,
      'code'      : code,
      'sectionId' : sectionId,
      'year'      : year,
      'month'     : month,
      'day'       : day,
      'time'      : time
    });
  }

  User _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return User(
        name: snapshot.data['name'],
        code: snapshot.data['code'],
        orgId : snapshot.data['orgId'],
        isAdmin: snapshot.data['isAdmin'],
        isGranted: snapshot.data['isGranted'],
    );
  }

  Stream<User> get userData{
    CollectionReference userCollection = organizationCollection.document(PrefManager.orgId).collection('users');
    return userCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  List<AttendanceHistory> _userHistoryListDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((history) => AttendanceHistory(
      userName: history.data['userName'],
      code: history.data['code'],
      sectionId: history.data['sectionId'],
      day: history.data['day'],
      month: history.data['month'],
      year: history.data['year'],
      time: history.data['time'],
      org: history.data['org'],
      userId: history.data['userId'],
    )
    ).toList();
  }

  Stream<List<AttendanceHistory>> get userHistoryData{
    CollectionReference userHistoryCollection =
    organizationCollection.document(PrefManager.orgId).collection('history');
    return userHistoryCollection
        .snapshots()
        .map(_userHistoryListDataFromSnapshot);
  }

  Organization _orgDataFromSnapshot(DocumentSnapshot snapshot) {
    return Organization(
      id: snapshot.data['id'],
      name: snapshot.data['name'],
      description: snapshot.data['description'],
      latitude : snapshot.data['latitude'],
      longitude: snapshot.data['longitude'],
      validateStudentLocation: snapshot.data['validateStudentLocation'],
      sections: snapshot.data['sections'],
    );
  }

  Stream<Organization> get orgData{
    return organizationCollection
        .document(PrefManager.orgId)
        .snapshots()
        .map(_orgDataFromSnapshot);
  }

  List<Organization> _orgListDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((org) => Organization(
      id: org.data['id'],
      name: org.data['name'],
      description: org.data['description'],
      latitude : org.data['latitude'],
      longitude: org.data['longitude'],
      validateStudentLocation: org.data['validateStudentLocation'],
      sections: org.data['sections'],
    )
    ).toList();
  }

  Stream<List<Organization>> get orgListData{
    return organizationCollection
        .snapshots()
        .map(_orgListDataFromSnapshot);
  }

}
