import 'package:flutter/material.dart';
import 'package:mini_map/helpers/auth.dart';

import '../helpers/constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const _email = "email";
  bool _isLoading = false;

  final _form = GlobalKey<FormState>();
  final Map<String, dynamic> _initValues = {_email: ''};

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if ((isValid ?? false) == false || _isLoading) {
      return;
    }
    _form.currentState?.save();

    showPasswordStatus();
  }

  Future showPasswordStatus() async {
    final email = _initValues[_email];

    setState(() {
      _isLoading = true;
    });

    final String response = await forgotPassword(email: email);
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response)));
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
                  'Forgot Password',
                  style: heading,
                ),
                const SizedBox(
                  height: kDefaultMargin / 5,
                ),
                Text(
                  'a password reset link would be send to your mail',
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
                  height: kDefaultMargin * 2,
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
                              'Reset Password',
                              style: bodyText1.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
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
