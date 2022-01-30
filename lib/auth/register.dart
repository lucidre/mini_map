import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_map/auth/login.dart';
import 'package:mini_map/helpers/auth.dart';
import 'package:mini_map/helpers/page_route.dart';

import '../helpers/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const _email = "email";

  static const _password = "password";
  static const _retypePassword = "retypePassword";

  final Map<String, dynamic> _initValues = {
    _email: '',
    _password: '',
    _retypePassword: '',
  };

  final passwordTextEditingController = TextEditingController(text: "");
  final retypePasswordTextEditingController = TextEditingController(text: "");
  bool _isPasswordHidden = true;
  bool _isLoading = false;
  bool _isRetypePasswordHidden = true;
  final _passwordFocusNode = FocusNode();
  final _retypePasswordFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _retypePasswordFocusNode.dispose();
    passwordTextEditingController.dispose();
    retypePasswordTextEditingController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    passwordTextEditingController.addListener(() {
      _initValues[_password] = passwordTextEditingController.text;
    });
    retypePasswordTextEditingController.addListener(() {
      _initValues[_retypePassword] = retypePasswordTextEditingController.text;
    });
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if ((isValid ?? false) == false || _isLoading) {
      return;
    }
    _form.currentState?.save();
    showRegistrationStatus();
  }

  Future showRegistrationStatus() async {
    final password = _initValues[_password];
    final email = _initValues[_email];

    setState(() {
      _isLoading = true;
    });

    final String response = await signUp(email: email, password: password);

    switch (response) {
      case '--':
        //login successful_proceed
        showSuccessDialog('Registration Successful, Please Wait..');
        break;
      default:
        //error occurred, handle error
        showErrorDialog(response);
        break;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void showErrorDialog(String error) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1;
    Dialog dialog = Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 50,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              error,
              style: bodyText1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    showGeneralDialog(
      context: context,
      barrierLabel: "Emergency Error",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => dialog,
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(anim),
        child: child,
      ),
    );
  }

  void showSuccessDialog(String message) {
    final textTheme = Theme.of(context).textTheme;
    final bodyText1 = textTheme.bodyText1;
    Dialog dialog = Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              message,
              style: bodyText1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    showGeneralDialog(
      context: context,
      barrierLabel: "Emergency Error",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => dialog,
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(anim),
        child: child,
      ),
    );

    Timer(const Duration(milliseconds: 3000), () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var heading = themeData.textTheme.headline1;
    var bodyText1 = themeData.textTheme.bodyText1;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: SingleChildScrollView(
              child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  logoLocation,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                  //it is for the image
                ),
                Text(
                  'Register',
                  style: heading!.copyWith(color: kDeepBlue),
                ),
                const SizedBox(
                  height: kDefaultMargin / 5,
                ),
                Text(
                  'Set up your account',
                  style: bodyText1!.copyWith(color: kDeepBlue),
                ),
                const SizedBox(
                  height: kDefaultMargin * 2,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Email',
                    style: bodyText1.copyWith(
                        fontWeight: FontWeight.bold, color: kDeepBlue),
                  ),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Please enter your email address",
                  ),
                  style: bodyText1.copyWith(fontSize: 18),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide your email.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _initValues[_email] = value ?? "";
                  },
                ),
                const SizedBox(
                  height: kDefaultMargin,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Password',
                    style: bodyText1.copyWith(
                        fontWeight: FontWeight.bold, color: kDeepBlue),
                  ),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  obscureText: _isPasswordHidden,
                  controller: passwordTextEditingController,
                  focusNode: _passwordFocusNode,
                  enableSuggestions: !_isPasswordHidden,
                  autocorrect: !_isPasswordHidden,
                  style: bodyText1.copyWith(fontSize: 18),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: kDeepBlue,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                    hintText: "Set a secure and strong password",
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide  your password';
                    } else if (value != _initValues[_retypePassword]) {
                      return 'Passwords are not the same';
                    } else if (value.length < 6) {
                      return 'Password must be more than 6 letters';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(_retypePasswordFocusNode);
                  },
                  onSaved: (value) {
                    _initValues[_password] = value ?? "";
                  },
                ),
                const SizedBox(
                  height: kDefaultMargin,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Retype Password',
                    style: bodyText1.copyWith(
                        fontWeight: FontWeight.bold, color: kDeepBlue),
                  ),
                ),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: retypePasswordTextEditingController,
                  obscureText: _isRetypePasswordHidden,
                  focusNode: _retypePasswordFocusNode,
                  enableSuggestions: !_isRetypePasswordHidden,
                  autocorrect: !_isRetypePasswordHidden,
                  style: bodyText1.copyWith(fontSize: 18),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isRetypePasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: kDeepBlue,
                      ),
                      onPressed: () {
                        setState(() {
                          _isRetypePasswordHidden = !_isRetypePasswordHidden;
                        });
                      },
                    ),
                    hintText: "Please enter your password again",
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide  your password';
                    } else if (value != _initValues[_password]) {
                      return 'Passwords are not the same';
                    } else if (value.length < 6) {
                      return 'Password must be more than 6 letters';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: kDefaultMargin,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kDeepBlue,
                        textStyle: bodyText1.copyWith(
                          color: Colors.white,
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        _saveForm();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : Text(
                                'Register',
                                style: bodyText1.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      )),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: bodyText1.copyWith(fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            CustomPageRoute(screen: const LoginScreen()),
                            (route) => route.isFirst);
                      },
                      child: const Text(
                        'Sign in',
                      ),
                      style: TextButton.styleFrom(
                          textStyle: bodyText1.copyWith(
                              fontSize: 18, color: kDeepBlue)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: kDefaultMargin * 2,
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Terms clicked')));
                    },
                    child: const Text(
                      'Terms of use. Privacy policy',
                    ),
                    style: TextButton.styleFrom(
                      textStyle: bodyText1.copyWith(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
