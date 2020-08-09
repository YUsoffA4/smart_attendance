import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../authentication/user_repository.dart';
import '../models/organization.dart';

import '../prefs/pref_manager.dart';

class OrganizationLocation extends StatefulWidget {
  static const String routeName = "OrganizationLocation";
  @override
  _OrganizationLocationState createState() => _OrganizationLocationState();
}

class _OrganizationLocationState extends State<OrganizationLocation> {
  bool isLoading = false;
  GoogleMapController controller;
  var _mapType = [MapType.normal, MapType.satellite, MapType.hybrid];
  int index = 2;
  bool isMarkerClicked = false;
  Widget Info = Container(
    color: Colors.transparent,
  );

  Future start_map;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Stack(
            children: <Widget>[
              StreamBuilder<Organization>(
                  stream: UserRepository().orgData,
                  builder: (context, snapshot) {
                  return GoogleMap(
                    onTap: (loc) {
                      setState(() {
                        isMarkerClicked = false;
                        Info = Container(
                          color: Colors.transparent,
                        );
                      });
                    },
                    mapType: _mapType[index],
                    zoomGesturesEnabled: true,
                    //onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(PrefManager.orgLat, PrefManager.orgLng),
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                        onTap: () {
                          isMarkerClicked = true;
                          if(snapshot.hasData){
                            List<String> sections =
                            snapshot.data
                                .sections.map((e) => e.toString()).toList();
                            PrefManager.setOrganizationData(
                              sections: sections,
                              name: snapshot.data.name,
                              description: snapshot.data.description,
                            );
                          setState(() {
                            Info = Container(
                                padding: const EdgeInsets.all(10.0),
                                height: MediaQuery.of(context).size.height * 0.22,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                          snapshot.data.name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.0
                                        ),
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                        snapshot.data.description,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white.withAlpha(180),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                )
                            );
                          });
                          }else{
                            Center(child: CircularProgressIndicator());
                          }
                        },
                        markerId: MarkerId("1"),
                        position: LatLng(PrefManager.orgLat, PrefManager.orgLng),
                        infoWindow: InfoWindow(
                          title: PrefManager.orgName,
                        ),
                      )
                    },
                  );
                }
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50)),
                  child: BackButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.white,
                  )),
              isMarkerClicked
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.transparent,
                          width: double.infinity,
                          //height: 200.0,
                          child: Info),
                    )
                  : Container(),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ))
                  : Container()
            ],
          ),
        );
  }
}
