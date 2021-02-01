import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  bool isLoading = false;


   var loadingKit = Center(
        child: Column(children: [
          SizedBox(height: 20,),
          SpinKitSquareCircle(
          color: mainColor,
          size: 50.0,
        ),
        ],),
      );
      
  getAction() async {
    setState(() {
      isLoading = true;
    }); 

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey("account")){
        Navigator.pushReplacementNamed(context, '/home');
      }else{
        if(prefs.containsKey("isRegisterd")){
          Navigator.pushReplacementNamed(context, '/login');
        }else{
          Navigator.pushReplacementNamed(context, '/');
        }
      }
      

    setState(() {
      isLoading = false;
    });

  }

  @override
  void initState() {
    super.initState();
    getAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Image.asset("assets/images/logo.png" , width: 100,)),

        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'loading'.tr(),
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xff514e4e),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        )


        ],),
    ),);
  }
}