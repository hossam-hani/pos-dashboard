import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';
import '../models/account.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/Notification.dart';

class AccountService {
  static Future<List<User>> getUsers(String currentPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      final response = await dio.get("$baseUrl/users?page=$currentPage");
      List<User> temp = [];
      response.data["data"].forEach((post) => temp.add(User.fromJson(post)));
      return temp;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<List<NotificationModel>> getNotifications(String currentPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      Response response = await dio.get("$baseUrl/notifications?page=$currentPage");
      print(response);
      List<NotificationModel> temp = [];
      response.data["data"].forEach((post) => temp.add(NotificationModel.fromJson(post)));
      return temp;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<Account> createAccount(
      {String storeName,
      String link,
      String currency,
      String country,
      String name,
      String email,
      String phone,
      String password,
      String category}) async {
    try {
      Response response = await Dio().post(
        "$baseUrl/user/register",
        data: {
          "store_name": storeName,
          "link": link,
          "currency": currency,
          "country": country,
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
          "category": category,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status < 600;
          },
        ),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("account", jsonEncode(response.data));
      prefs.setBool("isRegisterd", true);

      return Account.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<User> saveUser(
      {String name,
      String email,
      String password,
      String phone,
      String role,
      bool isBlocked,
      String id,
      String inventoryId,
      bool tax1,
      bool tax2,
      bool tax3}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      Response response = await dio.post(
        id != null ? "$baseUrl/users/$id" : "$baseUrl/users",
        data: id == null
            ? {
                "name": name,
                "email": email,
                "password": password,
                "phone": phone,
                "role": role,
                "inventory_id": inventoryId,
                "tax1": tax1 ? 1 : 0,
                "tax2": tax2 ? 1 : 0,
                "tax3": tax3 ? 1 : 0,
              }
            : {
                "name": name,
                "email": email,
                "phone": phone,
                "role": role,
                "is_blocked": isBlocked ? "1" : "0",
                "inventory_id": inventoryId,
                "tax1": tax1 ? 1 : 0,
                "tax2": tax2 ? 1 : 0,
                "tax3": tax3 ? 1 : 0,
              },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status < 600;
          },
        ),
      );

      print(response);

      User temp;
      temp = User.fromJson(response.data);
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

  static Future<Account> login({@required String email, @required String password}) async {
    Response response = await Dio().post("$baseUrl/user/login", data: {
      "email": email,
      "password": password,
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("account", jsonEncode(response.data));

    return Account.fromJson(response.data);
  }

  static Future<void> addTokenToUser({String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

    try {
      Response response = await dio.post("$baseUrl/user/token", data: {
        "token": token,
      });
    } catch (e) {
      print(e);
    }
    return null;
  }
}
