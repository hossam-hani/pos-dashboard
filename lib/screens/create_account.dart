import 'package:eckit/services/account_service.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  createNewUserAccount() async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString("name");
    String email = prefs.getString("email");
    String phone = prefs.getString("phone");
    String code = prefs.getString("code");
    String storeName = prefs.getString("storeName");
    String storeLink = prefs.getString("storeLink");
    String country = prefs.getString("country");
    String curreny = prefs.getString("curreny");
    String password = prefs.getString("password");
    String category = prefs.getString("category");

    await AccountService.createAccount(storeName: storeName,country: country,
    currency: curreny,category: category,password: password,name: name,email: email,phone: code+phone,link: storeLink);
    
    //TODO: unset strings keys 
    Navigator.pushReplacementNamed(context, '/home');

  }


  @override
  void initState() {
    super.initState();
    createNewUserAccount();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Center(child: Image.asset("assets/images/logo.png" , width: 150,)),
        SizedBox(height: 35,),
        Text('wait_until_finish'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w100),).tr(),
        Text('intro_des'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w100,color: mainColor),).tr(),
      ],),
    ),);
  }
}