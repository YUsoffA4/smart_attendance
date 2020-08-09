import 'package:flutter/material.dart';

import '../res/asset_path.dart';
import '../authentication/validators.dart';
import '../res/asset_manager.dart';
import '../authentication/user_repository.dart';

class ForgetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        centerTitle: true,
      ),
      body: ForgetPasswordForm(),
    );
  }
}

class ForgetPasswordForm extends StatefulWidget {
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset(AssetPath.APP_LOGO, height: 200),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      //icon: Icon(Icons.email),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor)),
                      contentPadding: const EdgeInsets.all(5)),
                  autovalidate: true,
                  autocorrect: false,
                  validator: (email) {
                    return !Validators.isValidEmail(email) ? 'Invalid Email' : null;
                  },
                ),
                SizedBox(height: 12.0),
                RaisedButton(
                  onPressed: _forgetPasswordPressed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Text('Send reset email'),
                )
              ],
            ),
          ),
        ),
        isLoading?Center(child:CircularProgressIndicator()):Container()
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  _forgetPasswordPressed() async {
    try {
      setState(() {isLoading = true;});
      await UserRepository().sendPasswordResetEmail(_emailController.text);
      await AssetManager.alertDialog(
          context,
          Center(
              child: Column(
            children: <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: Colors.green.withAlpha(180),
                size: 40.0,
              ),
              SizedBox(height: 5.0),
              Text(
                "Reset Email sent successfully!\nPlease check your email",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black.withAlpha(160)),
              ),
            ],
          )));
    } catch (e) {
      await AssetManager.alertDialog(
          context,
          Center(
              child: Column(
            children: <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red.withAlpha(180),
                size: 40.0,
              ),
              SizedBox(height: 5.0),
              Text(
                e.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.withAlpha(160)),
              ),
            ],
          )));
    }finally{
      setState(() {isLoading = false;});
      Navigator.pop(context);
    }
  }
}
