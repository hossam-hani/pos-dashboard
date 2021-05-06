import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomeButton extends StatelessWidget {
  String title;
  IconData icon;
  dynamic handler;
  bool mainColor;

  CustomeButton({this.title,this.icon,this.handler,this.mainColor = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: handler,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
        height: 40.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            icon == null ? SizedBox() :FaIcon(icon,color: Colors.white),
            icon == null ? SizedBox() : SizedBox(width: 10,),
            Text(title.tr(),
            style: TextStyle(
            fontSize: 18,
            color: const Color(0xffffffff),
            fontWeight: FontWeight.w300,),textAlign: TextAlign.center,
            ).tr()
          ],),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color:  Color( mainColor ? 0xff1e272e : 0xff000000),
        ),
        ),
      ),
    );
  }

}