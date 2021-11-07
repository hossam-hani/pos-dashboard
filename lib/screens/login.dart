import 'package:eckit/const.dart';
import 'package:eckit/services/account_service.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../validator.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController(text: 'Abdelbari.h@gmail.com');
  TextEditingController password = new TextEditingController(text: '35603282');
  bool isLoading = false;

  var loadingKit = Center(
    child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        SpinKitSquareCircle(
          color: mainColor,
          size: 50.0,
        ),
      ],
    ),
  );

  login() async {
    setState(() {
      isLoading = true;
    });
    /*
[02/10, 18:38] Hossam Hani: Abdelbari.h@gmail.com
[02/10, 18:38] Hossam Hani: 35603282
    */

    if (!_formKey.currentState.validate()) return;

    try {
      await AccountService.login(email: email.text, password: password.text);
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      Fluttertoast.showToast(
        msg: "تأكد من البريد او كلمة المرور",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Center(
                      child: Image.asset(
                    "assets/images/logo.png",
                    width: 100,
                  )),
                  CustomeTextField(
                    controller: email,
                    validator: Validator.notEmpty,
                    hintTxt: "email".tr(),
                    labelTxt: "email_label".tr(),
                  ),
                  CustomeTextField(
                    controller: password,
                    validator: Validator.notEmpty,
                    hintTxt: "password_hint".tr(),
                    labelTxt: "password_label".tr(),
                    obscureTextbool: true,
                  ),
                ],
              ),
              SizedBox(height: 20),
              isLoading
                  ? loadingKit
                  : InkWell(
                      onTap: login,
                      child: Container(
                        width: double.infinity,
                        height: 46.0,
                        child: Center(
                          child: Text(
                            'login'.tr(),
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xff1e272e),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomeTextField extends StatelessWidget {
  String hintTxt;
  String labelTxt;
  TextEditingController controller;
  dynamic validator;
  bool obscureTextbool;

  CustomeTextField({this.hintTxt, this.labelTxt, this.controller, this.validator, this.obscureTextbool = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureTextbool,
      validator: validator,
      controller: controller,
      decoration: new InputDecoration(
          hintText: hintTxt,
          labelText: labelTxt,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFECDFDF)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFECDFDF)),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFECDFDF)),
          )),
    );
  }
}
