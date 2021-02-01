import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../const.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: InkWell(
        onTap: (){
          Navigator.pushNamed(context, '/select_category');
        },
        child: Container(
        child: Center(
          child: Text(
            'start',
            style: TextStyle(
              fontSize: 25,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ).tr(),
        ),
        width: double.infinity,
        height: 66.0,
        decoration: BoxDecoration(
          color: mainColor,
        ),
      ),
      ),
      body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Center(child: Image.asset("assets/images/logo.png" , width: 150,)),
        SizedBox(height: 28,),
        Text('start_your_online_shop',style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),).tr(),
        Text('intro_des',textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w100),).tr(),
        SizedBox(height: 20,),
        InkWell(
          onTap: () => Navigator.pushNamed(context, '/login'),
          child: Text(
            'login'.tr(),
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