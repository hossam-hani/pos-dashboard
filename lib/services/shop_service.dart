


import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/models/category.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../const.dart';

class ShopService{

  static Future<Shop> getShopDetials() async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response = await dio.get("$baseUrl/shop/details");        
        return Shop.fromJson(response.data["shop"]);
      } catch (e) {
        print(e);
      }

      return null;
  }



    static Future<Shop> saveDetails({String whatsapp_contact,String phone_number, 
    String facebook_link,String instagram_link,String description,
    String sliderimage_1,String sliderimage_2,String sliderimage_3,String sliderimage_4,String sliderimage_5,
    bool isActive , String logo
    , String gaId, String pixelId}) async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response = await dio.post("$baseUrl/shop/details",data: {
          "whatsapp_contact" : whatsapp_contact,
          "phone_number" : phone_number,
          "facebook_link" : facebook_link,
          "instagram_link" : instagram_link,
          "description" : description,
          "sliderimage_1" : sliderimage_1,
          "sliderimage_2" : sliderimage_2,
          "sliderimage_3" : sliderimage_3,
          "sliderimage_4" : sliderimage_4,
          "sliderimage_5" : sliderimage_5,
          "is_active" : isActive,
          "logo" : logo,
          "ga_id" : gaId,
          "pixel_id" : pixelId,
        });

        Shop temp;
        temp = Shop.fromJson(response.data);
    

        Fluttertoast.showToast(
        msg: "success".tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );

        return temp;
      } catch (e) {
        print(e);
      }
      return null;
  }


}