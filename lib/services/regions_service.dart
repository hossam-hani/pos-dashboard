import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/models/region.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../const.dart';

class RegionsServices {
  static Future<List<Region>> getRegions(String currentPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      Response response = await dio.get("$baseUrl/regions?page=$currentPage");
      print(response);
      List<Region> temp = [];
      response.data["data"].forEach((post) => temp.add(Region.fromJson(post)));
      return temp;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<List<Region>> getAllMainRegions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      Response response = await dio.get("$baseUrl/regions/main");
      print(response);
      List<Region> temp = [];
      response.data.forEach((post) => temp.add(Region.fromJson(post)));
      return temp;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<Region> saveRegion({
    String name,
    String fees,
    bool isActive,
    String regionId,
    String id,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    try {
      final dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      final data = regionId != null
          ? {"name": name, "is_active": isActive, "fees": fees, "region_id": regionId}
          : {"name": name, "is_active": isActive};
      final response = await dio.post(id != null ? "$baseUrl/regions/$id" : "$baseUrl/regions",
          data: data,
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 600;
            },
          ));

      print(response.data);

      Region temp;
      temp = Region.fromJson(response.data);
      Fluttertoast.showToast(
          msg: "success".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      return temp;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
