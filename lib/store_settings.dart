import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eckit/components/customeButton.dart';
import 'package:eckit/models/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';


class StoreSettings extends StatefulWidget {
  
  dynamic changePageHandler;

  StoreSettings({this.changePageHandler});

  @override
  _StoreSettingsState createState() => _StoreSettingsState();
}

class _StoreSettingsState extends State<StoreSettings> {
  DateTime startFrom = DateTime.now();
  DateTime endAt = DateTime.now();

  bool isLoading = false;
  String sales;
  String ordersNumbers;
  String customers;
  String currency;

  search() async {
    setState(() {
      isLoading = true;
    });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

    try {
      
      Response response = await dio.post("$baseUrl/reports",data: {
        "startAt" : DateFormat('yyyy-MM-dd').format(startFrom),
        "endAt" : DateFormat('yyyy-MM-dd').format(endAt),
      });

      setState(() {
        sales = response.data["sales"].toString();
        customers = response.data["customerNo"].toString();
        ordersNumbers = response.data["orderNo"].toString();
        currency = response.data["currency"].toString();
      });

  
    } catch (e) {
    }


    setState(() {
      isLoading = false;
    });
  }


  var loadingKit = Center(
        child: Column(children: [
          SizedBox(height: 20,),
          SpinKitSquareCircle(
          color: mainColor,
          size: 50.0,
        ),
        SizedBox(height: 10,),
        Text("loading".tr())
        ],),
      );
      
  @override
  Widget build(BuildContext context) {
    return Column(children: [

      SizedBox(height: 10,),

      Row(children: [
        FaIcon(FontAwesomeIcons.store),
        SizedBox(width: 10,),
        Text("store".tr(),style: TextStyle(fontSize: 20),)
      ],),

      SizedBox(height: 10,),



      CustomeButton(title: "edit_store_settings".tr(),handler: () => {
        Navigator.pushNamed(context, '/edit_shop_details')
      },),


      CustomeButton(
        title: "logout".tr(),handler: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("account");
        Navigator.pushNamed(context, '/login');
      },),


      Divider(),

      Row(children: [

      Expanded(
        child: FlatButton(
        onPressed: () {
              DatePicker.showDatePicker(context,showTitleActions: true,minTime: DateTime(2021, 1, 1),
              maxTime: DateTime(2050, 1, 1), onChanged: (date) {
                setState(() {
                  startFrom = date;
                });
              }, onConfirm: (date) {
                setState(() {
                  startFrom = date;
                });
                }, 
              currentTime: startFrom,
              locale: LocaleType.ar);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
              'startFrom'.tr(),
              style: TextStyle(color: Colors.blue),
        ),
        Text(
              startFrom.toString(),
              style: TextStyle(color: Colors.grey,fontFamily: "Lato",fontSize: 12),
        )
        ],)),
        ),

      Expanded(
        child: FlatButton(
        onPressed: () {
              DatePicker.showDatePicker(context,showTitleActions: true,minTime: DateTime(2021, 1, 1),
              maxTime: DateTime(2050, 1, 1), onChanged: (date) {
                setState(() {
                  endAt = date;
                });
              }, onConfirm: (date) {
                setState(() {
                  endAt = date;
                });
                }, 
              currentTime: endAt,
              locale: LocaleType.ar);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
              'endAt'.tr(),
              style: TextStyle(color: Colors.blue),
        ),
        Text(
              endAt.toString(),
              style: TextStyle(color: Colors.grey,fontFamily: "Lato",fontSize: 12),
        )
        ],)),
        ),

      ],),

      SizedBox(height: 10,),

      CustomeButton(title: "confirm".tr(),handler: search,),

      isLoading ? loadingKit : sales == null ? SizedBox() : Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          DataItem(lable: "المبيعات", contenct: "$sales $currency", icon: FaIcon(FontAwesomeIcons.dollarSign,color: Colors.white,),),
          DataItem(lable: "عدد الطلبات", contenct: "$ordersNumbers", icon: FaIcon(FontAwesomeIcons.cartArrowDown,color: Colors.white,),),
          DataItem(lable: "عدد العملاء", contenct: "$customers", icon: FaIcon(FontAwesomeIcons.users,color: Colors.white,),),
        ],),
      ),

    ],);
  }
}


class DataItem extends StatelessWidget {

  String lable;
  String contenct;
  FaIcon icon;

  DataItem({this.lable,this.contenct,this.icon});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            SizedBox(height: 10,),

    Text(
      lable,
      style: TextStyle(
        fontSize: 20,
        color: const Color(0xff000000),
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    ),
        SizedBox(height: 10,),



  Container(
    height: 51.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: const Color(0xffff7700),
    ),
    child: Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null ? icon : SizedBox(),
          SizedBox(width: 10,),
          Text(
           contenct,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 15,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  )

    ],);
  }
}