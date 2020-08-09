import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'prefs/pref_manager.dart';
import 'authentication/authentication_bloc/authentication_bloc.dart';
import 'authentication/user_repository.dart';
import 'ui/home_screen.dart';
import 'ui/login_screen.dart';
import 'ui/splash_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await PrefManager.initializeOrganizationData();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AuthenticationStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatefulWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smart Attendance",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff192053)
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if(PrefManager.current_location == null){
            return Scaffold(
              body: Stack(
                children: <Widget>[
                  Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("In order to use the app, you must grant location permission",textAlign: TextAlign.center,),
                      SizedBox(height: 100),
                      FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        color: Color(0xff192053),
                        child: Text("Grant Permission", style: TextStyle(color: Colors.white),),
                        onPressed: ()async{
                          setState(() {isLoading = true;});
                          await PrefManager.getUserLocation();
                          setState(() {isLoading = false;});
                        },
                      )
                    ],
                  )),
                  isLoading?Center(child: CircularProgressIndicator()):Container()
                ],
              ),
            );
          }
          if (state is AuthenticationFailure) {
            return LoginScreen(userRepository: widget._userRepository);
          }
          if (state is AuthenticationSuccess) {
            return HomeScreen(userId: state.userId);
          }
          return SplashScreen();
        },
      ),

    );
  }
}
