import 'package:flutter/material.dart';

import '../authentication/user_repository.dart';
import '../models/formatted_time.dart';
import '../models/history.dart';
import '../prefs/pref_manager.dart';
import '../widgets/history_item.dart';


class StudentHistory extends StatefulWidget {
  static const String routeName = "StudentHistory";
  final UserRepository userRepository;

  StudentHistory({this.userRepository});

  @override
  _StudentHistoryState createState() => _StudentHistoryState();
}

class _StudentHistoryState extends State<StudentHistory> {
  List choices = [];
  List<String> selectedString = [];
  List<bool> selected = List.filled(100, false);
  int noSelected  = 0;
  String searchString = '';
  bool isLoading = false;

  List<AttendanceHistory> _attendanceHistory = List();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("My History"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<AttendanceHistory>>(
          stream: widget.userRepository.userHistoryData,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              _attendanceHistory.clear();
              _attendanceHistory.addAll(
                  snapshot.data.map(
                          (historyItem) => historyItem)
                      .where((element) => element.userId == widget.userRepository.uid)
              );
              return Column(
                children: <Widget>[
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
                  Expanded(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: _attendanceHistory.map((historyItem) {
                          if (noSelected == 0) {
                            return HistoryItem(
                              section: historyItem.sectionId,
                              date: FormattedTime(
                                  day: historyItem.day,
                                  month: historyItem.month,
                                  year: historyItem.year,
                                  time: historyItem.time
                              ).toString(),
                            );
                          }
                          return selectedString.contains(historyItem.sectionId)
                              ? HistoryItem(
                            section: historyItem.sectionId,
                            date: FormattedTime(
                                day: historyItem.day,
                                month: historyItem.month,
                                year: historyItem.year,
                                time: historyItem.time
                            ).toString(),
                          )
                              : Container();
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
