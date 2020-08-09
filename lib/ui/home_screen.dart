import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';

import 'about.dart';
import '../authentication/user_repository.dart';
import '../models/formatted_time.dart';
import '../models/organization.dart';
import '../models/user.dart';
import '../prefs/pref_manager.dart';
import '../res/asset_manager.dart';
import '../res/asset_path.dart';
import '../ui/generat_attendance.dart';
import '../ui/generate_qr.dart';
import '../ui/org_location.dart';
import '../ui/student_history.dart';
import '../widgets/main_icon.dart';
import '../authentication/authentication_bloc/authentication_bloc.dart';


class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen({Key key, @required this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User _userData;

  @override
  Widget build(BuildContext context) {
    final MQH = MediaQuery.of(context).size.height;
    return StreamBuilder<Organization>(
      stream: UserRepository().orgData,
      builder: (context, snap) {
        return Scaffold(
          drawer: Drawer(
            elevation: 8.0,
              child: StreamBuilder<User>(
                stream: UserRepository(uid: widget.userId).userData,
                builder: (context, snapshot) {
                  return snapshot.hasData?Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 35.0),
                        height: MQH * 0.28,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withAlpha(120),
                                blurRadius: 5.0,
                              offset: Offset(0,0),
                            )
                          ],
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white.withOpacity(0.98)
                        ),
                        child: Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              minRadius: 45.0,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: Image.asset(
                                    AssetPath.USER_IMAGE,
                                  height: 140.0,
                                  width: 140.0,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Column(
                                  children: <Widget>[
                                    Text(
                                      snapshot.data.name,
                                      style: TextStyle(
                                          color: Colors.black.withAlpha(200),
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      snapshot.data.code,
                                      style: TextStyle(
                                          color: Colors.black.withAlpha(200),
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                          ],
                        )),
                      ),
                     // Divider(thickness: 2.0, height: 2.0),
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            ListTile(leading: Icon(Icons.home), title: Text("Home"), onTap: ()=>Navigator.pop(context),),
                            ListTile(leading: Icon(Icons.supervised_user_circle), title: Text("About"), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_) => About())),),
                            ListTile(leading: Icon(Icons.share), title: Text("Share"), onTap: ()async{
                              await FlutterShare.share(
                                  title: "Smart Attendance",
                                  text: "Download the smart attendance app now: ",
                                  linkUrl: AssetPath.APP_LINK
                              );
                            },),
                            ListTile(leading: Icon(Icons.rate_review), title: Text("Rate"), onTap: () => AssetManager.launchUrl(AssetPath.APP_LINK),),
                          ],
                        ),
                      ),
                    ],
                  ):Center(child: CircularProgressIndicator());
                }
              )),
          appBar: AppBar(
            centerTitle: true,
            title: Text('Home'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(
                    AuthenticationLoggedOut(),
                  );
                },
              )
            ],
          ),
          body: StreamBuilder<User>(
            stream: UserRepository(uid: widget.userId).userData,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                _userData = snapshot.data;
                if(snap.hasData){
                  List<String> sections =
                  snap.data
                      .sections.map((e) => e.toString()).toList();
                  PrefManager.setOrganizationData(
                    id: snap.data.id,
                    lat: snap.data.latitude,
                    lng: snap.data.longitude,
                    sections: sections,
                    name: snap.data.name,
                    description: snap.data.description,
                    validate: snap.data.validateStudentLocation
                  );
                }
                if(snapshot.data.isAdmin){
                  if(snapshot.data.isGranted){
                    return GridView(
                      padding: EdgeInsets.only(top: MQH * 0.2),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0
                      ),
                      children: <Widget>[
                        MainIcon(title: "Check General Attendance", image: AssetPath.GENERAL_IMAGE, onTab: _onGeneralAttendanceTabbed),
                        MainIcon(title: PrefManager.orgName + " Location", image: AssetPath.ADMIN_LOCATION_IMAGE, onTab: _onLocationTabbed,),
                        MainIcon(title: "Generate QR codes", image: AssetPath.GENERATE_IMAGE, onTab: _onGenerateQRTabbed,),
                      ],
                    );
                  }else{
                    return Center(child: Text("You are Not Granted to acces the data!\n\nPlease ask the administraitor to grant you permission.", textAlign: TextAlign.center,),);
                  }
                }
                else if(!snapshot.data.isAdmin){
                  return GridView(
                    padding: EdgeInsets.only(top: MQH * 0.2),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 3.0
                    ),
                    children: <Widget>[
                      MainIcon(title: "Scan QR", image: AssetPath.SCAN_IMAGE, onTab: _onScan),
                      MainIcon(title: PrefManager.orgName + " Location", image: AssetPath.LOCATION_IMAGE, onTab: _onLocationTabbed,),
                      MainIcon(title: "My History", image: AssetPath.HISTORY_IMAGE,onTab: _onHistoryTabbed),
                    ],
                  );
                }else{
                  BlocProvider.of<AuthenticationBloc>(context).add(
                    AuthenticationLoggedOut(),
                  );
                }
              }
              if(snapshot.hasError){
                return Center(child: Text("You are not registered in this organization!\nPlease login again with the correct organization", textAlign: TextAlign.center,));
              }
              return Center(child: CircularProgressIndicator());
            }
          ),
        );
      }
    );
  }

  String _qrResult;

  _onScan()async{
    _qrResult = await AssetManager.scan();
    if(_qrResult.contains("ERROR")){
      await AssetManager.alertDialog(
          context,
        Center(child: Text(_qrResult, style: TextStyle(color: Colors.red),))
      );
    }
    else if(PrefManager.orgSections.contains(_qrResult)){
      if(PrefManager.validateStudentLocation && !await PrefManager.isInOrganization()){
        await AssetManager.alertDialog(
            context,
            Center(child: Text(
              "You are not in the organization!\n\nonly scan QR when you are in your section.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            )
            )
        );
        return;

      }
      FormattedTime formattedTime = AssetManager.formattedDate();
      try {
        await UserRepository(uid: widget.userId).setUserHistory(
            name: _userData.name,
            sectionId: _qrResult,
            year: formattedTime.year,
            month: formattedTime.month,
            day: formattedTime.day,
            time: formattedTime.time,
            code: _userData.code
        );
        await AssetManager.alertDialog(
            context,
            Center(
                child: Column(
                  children: <Widget>[
                    Icon(Icons.check_circle_outline, color: Colors.green.withAlpha(180),size: 40.0,),
                    SizedBox(height: 5.0),
                    Text("You checked-in to",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black.withAlpha(160)),
                    ),
                    Text(_qrResult,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black.withAlpha(160), fontWeight: FontWeight.bold),
                    ),
                  ],
                )
            )
        );
      }catch(e){
        await AssetManager.alertDialog(
            context,
            Center(
                child: Column(
                  children: <Widget>[
                    Icon(Icons.error_outline, color: Colors.red.withAlpha(180),size: 40.0,),
                    SizedBox(height: 5.0),
                    Text(e.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black.withAlpha(160)),
                    ),
                  ],
                )
            )
        );
      }
    }
    else if(_qrResult.isNotEmpty){
      await AssetManager.alertDialog(
          context,
          Center(
              child: Text(
                "Wrong QR Code!\n Please scan the QR located in your section.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),))
      );
    }
    }

  _onHistoryTabbed()async{
    UserRepository _userRepository = UserRepository(uid: widget.userId);

    Navigator.push(context, MaterialPageRoute(
      builder: (_) => StudentHistory(userRepository: _userRepository)
    ));
  }

  _onLocationTabbed()async{
    await Navigator.push(context, MaterialPageRoute(
        builder: (_) => OrganizationLocation()
    ));
    setState(() {});
  }

  _onGeneralAttendanceTabbed()async{
    await Navigator.push(context, MaterialPageRoute(
        builder: (_) => GeneralHistory()
    ));
    setState(() {});
  }

  _onGenerateQRTabbed(){
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => GenerateQR()
    ));
  }
}
