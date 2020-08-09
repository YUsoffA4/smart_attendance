import 'package:flutter/material.dart';

import '../authentication/user_repository.dart';
import '../models/formatted_time.dart';
import '../models/history.dart';
import '../prefs/pref_manager.dart';
import '../res/asset_manager.dart';
import '../ui/pdf_screen.dart';
import '../widgets/general_history_item.dart';


class GeneralHistory extends StatefulWidget {
  static const String routeName = "GeneralHistory";
  @override
  _GeneralHistoryState createState() => _GeneralHistoryState();
}

class _GeneralHistoryState extends State<GeneralHistory> {
  List choices = [];
  List<String> selectedString = [];
  List<bool> selected = List.filled(100, false);
  int noSelected  = 0;
  String searchString = '';
  bool isLoading = false;
  DateTime _currentDate;
  bool _dateSelected = false;
  List<AttendanceHistory> _attendanceHistory = List();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: MaterialButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        color: Theme.of(context).primaryColor,
        child: Icon(Icons.print, color: Colors.white,),
        onPressed: ()async{
          if(selectedString.isNotEmpty) {
            for (String x in selectedString) {
              AssetManager.reportSection += x + ', ';
            }
          }
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => PdfScreen())
          );
          AssetManager.reportData = List();
          setState(() {});

        },
      ),
      appBar: AppBar(
        title: Text("General Attendance"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<AttendanceHistory>>(
          stream: UserRepository().userHistoryData,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              print(AssetManager.reportData.toString());
              AssetManager.reportDate = "";
              AssetManager.reportData = List();
              AssetManager.reportSection = "";
              _attendanceHistory.clear();
              _attendanceHistory.addAll(
                  snapshot.data.map(
                          (historyItem) => historyItem)
              );
              return Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    color: Color(0xffDDDDDD),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.search, color: Theme.of(context).primaryColor, size: 30,),
                        Expanded(
                          child: TextField(
                            onChanged: (val){setState(() {searchString = val;});},
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                fillColor: Colors.white.withAlpha(100),
                                hintText: 'Search by code...'
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: PrefManager.orgSections.length,
                      itemBuilder: (_, i) {
                        return _section(PrefManager.orgSections[i], selected[i], i);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 18.0,
                    child: Divider(thickness: 1.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _currentDate != null?Text("${_currentDate.day}/${_currentDate.month}/${_currentDate.year}"):Container(),
                        FloatingActionButton(
                          backgroundColor: _dateSelected?Colors.red:null,
                          child: Icon(Icons.date_range, color: Colors.white,),
                          onPressed: ()async{
                            if(_dateSelected){
                              _currentDate = null;
                              setState(() {_dateSelected = false;});
                            }else {
                              _currentDate = DateTime.now();
                              _currentDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2018, 12, 1),
                                lastDate: DateTime.now(),
                              );
                              print(_currentDate);
                              if(_currentDate != null) {
                                _dateSelected = true;
                                setState(() {});
                              }
                            }
                          },

                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: _attendanceHistory.map((historyItem) {

                          if (noSelected == 0 && searchString.isEmpty && _currentDate == null) {
                            AssetManager.reportData.add(historyItem);
                            return GeneralHistoryItem(
                              section: historyItem.sectionId,
                              date: FormattedTime(
                                  day: historyItem.day,
                                  month: historyItem.month,
                                  year: historyItem.year,
                                  time: historyItem.time
                              ).toString(),
                              name: historyItem.userName,
                              code: historyItem.code,
                            );
                          }

                          else if(noSelected == 0 && searchString.isNotEmpty && _currentDate == null){
                            if(historyItem.code.contains(searchString)) {
                              AssetManager.reportData.add(historyItem);
                              return GeneralHistoryItem(
                                section: historyItem.sectionId,
                                date: FormattedTime(
                                    day: historyItem.day,
                                    month: historyItem.month,
                                    year: historyItem.year,
                                    time: historyItem.time
                                ).toString(),
                                name: historyItem.userName,
                                code: historyItem.code,
                              );
                            }else{
                              return Container();
                            }
                          }
                          else if(noSelected != 0 && searchString.isNotEmpty && _currentDate == null){
                            if(selectedString.contains(historyItem.sectionId)
                                && historyItem.code.contains(searchString)) {
                              AssetManager.reportData.add(historyItem);
                              return GeneralHistoryItem(
                                section: historyItem.sectionId,
                                date: FormattedTime(
                                    day: historyItem.day,
                                    month: historyItem.month,
                                    year: historyItem.year,
                                    time: historyItem.time
                                ).toString(),
                                name: historyItem.userName,
                                code: historyItem.code,
                              );
                            }else{ return Container();}
                          }
                          else if(noSelected == 0 && searchString.isNotEmpty && _currentDate != null){
                            if(historyItem.code.contains(searchString)
                                && historyItem.year == _currentDate.year
                                && historyItem.month == _currentDate.month
                                && historyItem.day == _currentDate.day
                                ) {
                              AssetManager.reportDate = FormattedTime(
                                  day: _currentDate.day,
                                  month: _currentDate.month,
                                  year: _currentDate.year
                              ).toString();
                              AssetManager.reportData.add(historyItem);
                              return GeneralHistoryItem(
                                section: historyItem.sectionId,
                                date: FormattedTime(
                                    day: historyItem.day,
                                    month: historyItem.month,
                                    year: historyItem.year,
                                    time: historyItem.time
                                ).toString(),
                                name: historyItem.userName,
                                code: historyItem.code,
                              );
                            }else{
                              return Container();
                            }

                          }
                          else if(noSelected != 0 && searchString.isEmpty && _currentDate == null){
                            if(selectedString.contains(historyItem.sectionId)) {
                              AssetManager.reportData.add(historyItem);
                              return GeneralHistoryItem(
                                section: historyItem.sectionId,
                                date: FormattedTime(
                                    day: historyItem.day,
                                    month: historyItem.month,
                                    year: historyItem.year,
                                    time: historyItem.time
                                ).toString(),
                                name: historyItem.userName,
                                code: historyItem.code,
                              );
                            }
                             else{
                               return Container();

                            }
                          }
                          else if(noSelected != 0 && searchString.isEmpty && _currentDate != null){
                            if(selectedString.contains(historyItem.sectionId)
                                && historyItem.year == _currentDate.year
                                && historyItem.month == _currentDate.month
                                && historyItem.day == _currentDate.day
                                ) {
                              AssetManager.reportData.add(historyItem);
                              AssetManager.reportDate = FormattedTime(
                                  day: _currentDate.day,
                                  month: _currentDate.month,
                                  year: _currentDate.year
                              ).toString();
                              return GeneralHistoryItem(
                                section: historyItem.sectionId,
                                date: FormattedTime(
                                    day: historyItem.day,
                                    month: historyItem.month,
                                    year: historyItem.year,
                                    time: historyItem.time
                                ).toString(),
                                name: historyItem.userName,
                                code: historyItem.code,
                              );
                            }else{
                              return Container();
                            }
                          }
                          else if(noSelected == 0 && searchString.isEmpty && _currentDate != null){
                            if(historyItem.year == _currentDate.year
                                && historyItem.month == _currentDate.month
                                && historyItem.day == _currentDate.day) {
                              AssetManager.reportData.add(historyItem);
                              AssetManager.reportDate = FormattedTime(
                                  day: _currentDate.day,
                                  month: _currentDate.month,
                                  year: _currentDate.year
                              ).toString();
                              return GeneralHistoryItem(
                                section: historyItem.sectionId,
                                date: FormattedTime(
                                    day: historyItem.day,
                                    month: historyItem.month,
                                    year: historyItem.year,
                                    time: historyItem.time
                                ).toString(),
                                name: historyItem.userName,
                                code: historyItem.code,
                              );
                            }else{
                              return Container();
                            }
                          }
                          else{
                            if(historyItem.code.contains(searchString)
                                &&selectedString.contains(historyItem.sectionId)
                                && historyItem.year == _currentDate.year
                                && historyItem.month == _currentDate.month
                                && historyItem.day == _currentDate.day
                                ) {
                              AssetManager.reportDate = FormattedTime(
                                  day: _currentDate.day,
                                  month: _currentDate.month,
                                  year: _currentDate.year
                              ).toString();
                              AssetManager.reportData.add(historyItem);
                              return GeneralHistoryItem(
                                section: historyItem.sectionId,
                                date: FormattedTime(
                                    day: historyItem.day,
                                    month: historyItem.month,
                                    year: historyItem.year,
                                    time: historyItem.time
                                ).toString(),
                                name: historyItem.userName,
                                code: historyItem.code,
                              );
                            }else{
                              return Container();
                            }
                          }

                        }).toList(),

                      )
                  ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          }
      ),
    );
  }


  Widget _section(String title, bool x, int idx){
    bool tapped = x;
    Color _selected = Theme.of(context).accentColor;
    Color _unselected = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: (){
        print('Tapped');
        setState(() {
          if(selected[idx] == false){
            noSelected += 1;
            selectedString.add(title);
          }
          else{
            noSelected -= 1;
            selectedString.removeWhere((String val){return val == title;});
          }
          selected[idx] = !selected[idx];
          print(noSelected);
        });
      },
      child: Container(
        height: 50,
        //width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: tapped?_selected:_unselected
        ),
        child: Center(child: Text(title, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
      ),
    );
  }
}
