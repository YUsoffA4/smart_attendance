import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/organization.dart';
import '../prefs/pref_manager.dart';
import '../widgets/register_button.dart';
import '../authentication/authentication_bloc/authentication_bloc.dart';
import '../authentication/register_bloc/bloc.dart';
import '../authentication/user_repository.dart';



class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;

  RegisterScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register'),centerTitle: true,),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository: _userRepository),
          child: RegisterForm(userRepository: _userRepository),
        ),
      ),
    );
  }
}


class RegisterForm extends StatefulWidget {
  final UserRepository userRepository;
  RegisterForm({this.userRepository});
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  int _selectedOrganization;
  bool once = false;
  static List<Organization> orgs = List();
  RegisterBloc _registerBloc;
  bool isAdmin = false;
  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty
          && _nameController.text.isNotEmpty && _codeController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _nameController.addListener(_onNameChanged);
    _codeController.addListener(_onCodeChanged);
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<Organization>>(
      stream: widget.userRepository.orgListData,
      builder: (_, snapshot){
        if(snapshot.hasData){
          if(!once) {
            orgs.clear();
            orgs.addAll(snapshot.data.toList());
            _setOrganizationsDropdown();
            once = true;
          }
          return BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state.isSubmitting) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Registering...'),
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  );
              }
              if (state.isSuccess) {
                BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedIn());
                Navigator.of(context).pop();
              }
              if (state.isFailure) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Registration Failure'),
                          Icon(Icons.error),
                        ],
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
            },
            child: BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Form(
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height: 30.0),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Name',
                          ),
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          autovalidate: true,
                          validator: (_) {
                            return !state.isNameValid ? 'Invalid Name' : null;
                          },
                        ),
                        TextFormField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.comment),
                            labelText: 'Code',
                          ),
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          autovalidate: true,
                          validator: (_) {
                            return !state.isCodeValid ? 'Invalid Code' : null;
                          },
                        ),

                        Row(
                          children: <Widget>[
                            Icon(Icons.account_balance, color: Colors.black.withAlpha(130),),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 15.0, bottom: 12.0, left: 12.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: Colors.grey)
                                ),
                                //width: MQW,
                                child: DropdownButton(
                                  hint: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text('Select an Organization', textAlign: TextAlign.center,),
                                  ),
                                  elevation: 5,
                                  isExpanded: true,
                                  underline: Container(), // null
                                  iconSize: 35,
                                  onChanged: (val){setState(() => _selectedOrganization = val );},
                                  items: _orgsDropdownList,
                                  value: _selectedOrganization,
                                ),
                              ),
                            ),
                          ],
                        ),

                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          autovalidate: true,
                          validator: (_) {
                            return !state.isEmailValid ? 'Invalid Email' : null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.lock),
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          autocorrect: false,
                          autovalidate: true,
                          validator: (_) {
                            return !state.isPasswordValid ? 'Invalid Password' : null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("Student"),
                            Switch.adaptive(
                              value: isAdmin,
                              onChanged: (val){
                                setState(() {isAdmin = !isAdmin;});
                              },
                            ),
                            Text("Admin")
                          ],
                        ),
                        SizedBox(height: 40.0),
                        RegisterButton(
                          onPressed: isRegisterButtonEnabled(state)
                              ? _onFormSubmitted
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.add(
      RegisterEmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      RegisterPasswordChanged(password: _passwordController.text),
    );
  }

  void _onNameChanged() {
    _registerBloc.add(
      RegisterNameChanged(name: _nameController.text),
    );
  }

  void _onCodeChanged() {
    _registerBloc.add(
      RegisterCodeChanged(code: _codeController.text),
    );
  }

  void _onFormSubmitted() async{
    if(_selectedOrganization != null) {
      PrefManager.setUserName(_nameController.text);
      PrefManager.setUserCode(_codeController.text);
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
    }
    _registerBloc.add(
      RegisterSubmitted(
        orgId: orgs[_selectedOrganization].id,
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        code: _codeController.text,
        isAdmin: isAdmin
      ),
    );
  }


  List<DropdownMenuItem> _orgsDropdownList = List();

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

