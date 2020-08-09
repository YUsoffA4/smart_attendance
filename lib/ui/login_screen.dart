import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance/models/organization.dart';
import 'package:smart_attendance/prefs/pref_manager.dart';
import 'package:smart_attendance/res/asset_manager.dart';
import '../ui/forget_password_screen.dart';

import '../authentication/authentication_bloc/authentication_bloc.dart';
import '../widgets/create_account_button.dart';
import '../widgets/login_button.dart';
import '../authentication/login_bloc/bloc.dart';
import '../authentication/user_repository.dart';


class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'),centerTitle: true,),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginForm(userRepository: _userRepository),
      ),
    );
  }
}


class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _selectedOrganization;
  bool once = false;
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onLoginEmailChanged);
    _passwordController.addListener(_onLoginPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Organization>>(
      stream: UserRepository().orgListData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          if(!once) {
            orgs.clear();
            orgs.addAll(snapshot.data.toList());
            _setOrganizationsDropdown();
            once = true;
          }
          return BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.isFailure) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Login Failure'), Icon(Icons.error)],
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
              if (state.isSubmitting) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Logging In...'),
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  );
              }
              if (state.isSuccess) {
                BlocProvider.of<AuthenticationBloc>(context).add(
                    AuthenticationLoggedIn());
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Image.asset('assets/logo.png', height: 200),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //Icon(Icons.account_balance, color: Colors.black.withAlpha(130),),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 15.0, bottom: 12.0, left: 12.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: Colors.grey)
                              ),
                              //width: MQW,
                              child: DropdownButton(
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text('Organization',
                                    textAlign: TextAlign.center,),
                                ),
                                elevation: 5,
                                //isExpanded: true,
                                underline: Container(),
                                // null
                                iconSize: 35,
                                onChanged: (val) {
                                  setState(() => _selectedOrganization = val);
                                },
                                items: _orgsDropdownList,
                                value: _selectedOrganization,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              icon: Icon(Icons.email),
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Theme
                                      .of(context)
                                      .primaryColor)),
                              contentPadding: const EdgeInsets.all(5)
                          ),
                          autovalidate: true,
                          autocorrect: false,
                          validator: (_) {
                            return !state.isEmailValid ? 'Invalid Email' : null;
                          },
                        ),
                        SizedBox(height: 10),

                        SizedBox(height: 5),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.email),
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Theme
                                      .of(context)
                                      .primaryColor)),
                              contentPadding: const EdgeInsets.all(5)
                          ),
                          obscureText: true,
                          autovalidate: true,
                          autocorrect: false,
                          validator: (_) {
                            return !state.isPasswordValid
                                ? 'Invalid Password'
                                : null;
                          },
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 42.0),
                            InkWell(
                              child: Text("forget password?",
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: Theme
                                    .of(context)
                                    .primaryColor
                                    .withAlpha(200)),),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) => ForgetPasswordScreen()));
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              LoginButton(
                                onPressed: isLoginButtonEnabled(state)
                                    ? _onFormSubmitted
                                    : null,
                              ),

                              CreateAccountButton(
                                  userRepository: _userRepository),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginEmailChanged() {
    _loginBloc.add(
      LoginEmailChanged(email: _emailController.text),
    );
  }

  void _onLoginPasswordChanged() {
    _loginBloc.add(
      LoginPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    if(_selectedOrganization != null) {
      List<String> sections =
      orgs[_selectedOrganization]
          .sections.map((e) => e.toString()).toList();
      PrefManager.setOrganizationData(
          id: orgs[_selectedOrganization].id,
          name: orgs[_selectedOrganization].name,
          description: orgs[_selectedOrganization].description,
          lat: orgs[_selectedOrganization].latitude,
          lng: orgs[_selectedOrganization].longitude,
          sections: sections
      );
      _loginBloc.add(
        LoginWithCredentialsPressed(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
      return;
    }
    AssetManager.alertDialog(context, Text("You must choose an organization"));
  }


  List<DropdownMenuItem> _orgsDropdownList = List();
  static List<Organization> orgs = List();
  _setOrganizationsDropdown(){
    for(int i = 0 ; i < orgs.length ; i++){
      _orgsDropdownList.add(
        DropdownMenuItem(
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(orgs[i].name),
          ),
          value: i,
        ),
      );
    }
  }
}

