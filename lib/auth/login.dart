import 'package:flutter/material.dart';
import 'package:mini_map/auth/forgot_password.dart';
import 'package:mini_map/auth/resend_verification.dart';
import 'package:mini_map/helpers/auth.dart';
import 'package:mini_map/home/home.dart';

import '../helpers/constants.dart';
import '../helpers/page_route.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _email = "email";
  static const _password = "password";
  bool _isHidden = true;
  bool _isLoading = false;

  final _passwordFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final Map<String, dynamic> _initValues = {_email: '', _password: ''};

  @override
  void dispose() {
    _passwordFocusNode.dispose();

    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if ((isValid ?? false) == false || _isLoading) {
      return;
    }
    _form.currentState?.save();
    //login user here
    showLoginStatus();
  }

  Future showLoginStatus() async {
    var navigatorState = Navigator.of(context);
    final email = _initValues[_email];
    final password = _initValues[_password];

    setState(() {
      _isLoading = true;
    });

    final String response = await signIn(email: email, password: password);
    setState(() {
      _isLoading = false;
    });

    switch (response) {
      case '--':
        //login successful_proceed
        navigatorState.pushAndRemoveUntil(
            CustomPageRoute(screen: const HomeScreen()), (route) => false);
        break;
      default:
        //error occurred, handle error
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response)));
        break;
    }
  }

  Future googleSignIn() async {
    var navigatorState = Navigator.of(context);

    setState(() {
      _isLoading = true;
    });

    final String response = await signInWithGoogle();
    setState(() {
      _isLoading = false;
    });

    switch (response) {
      case '--':
        //login successful_proceed
        navigatorState.pushAndRemoveUntil(
            CustomPageRoute(screen: const HomeScreen()), (route) => false);
        break;
      default:
        //error occurred, handle error
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var heading = themeData.textTheme.headline1;
    var bodyText1 = themeData.textTheme.bodyText1;
    var bodyText2 = themeData.textTheme.bodyText2;
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
                  'Login',
                  style: heading,
                ),
                const SizedBox(
                  height: kDefaultMargin / 5,
                ),
                Text(
                  'Sign in to your account',
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
                  textInputAction: TextInputAction.done,
                  obscureText: _isHidden,
                  focusNode: _passwordFocusNode,
                  enableSuggestions: !_isHidden,
                  autocorrect: !_isHidden,
                  style: bodyText1.copyWith(fontSize: 18),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isHidden ? Icons.visibility : Icons.visibility_off,
                        color: kDeepBlue,
                      ),
                      onPressed: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      },
                    ),
                    hintText: "Enter your password.",
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide  your password';
                    } else if (value.length < 6) {
                      return 'Password must be more than 6 letters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _initValues[_password] = value ?? "";
                  },
                ),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(CustomPageRoute(
                            screen: const ForgotPasswordScreen()));
                      },
                      child: const Text(
                        'Forgot Password?',
                      ),
                      style: TextButton.styleFrom(
                        textStyle: bodyText2!.copyWith(color: kDeepBlue),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(CustomPageRoute(
                            screen: const ResendVerificationScreen()));
                      },
                      child: const Text(
                        'Resend Verification',
                      ),
                      style: TextButton.styleFrom(
                        textStyle: bodyText2.copyWith(color: kDeepBlue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: kDefaultMargin,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: kDeepBlue,
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
                              'Sign In',
                              style: bodyText1.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'or sign in with',
                      style: bodyText1.copyWith(fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        googleSignIn();
                      },
                      child: const Text(
                        'GOOGLE',
                      ),
                      style: TextButton.styleFrom(
                        textStyle:
                            bodyText1.copyWith(fontSize: 18, color: kDeepBlue),
                      ),
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
                          const SnackBar(content: Text('terms clicked')));
                    },
                    child: const Text(
                      'Terms of use. Privacy policy',
                    ),
                    style: TextButton.styleFrom(
                        textStyle: bodyText1.copyWith(fontSize: 18)),
                  ),
                ),
                const SizedBox(
                  height: kDefaultMargin / 2,
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
