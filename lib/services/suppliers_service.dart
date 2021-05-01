


import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/models/region.dart';
import 'package:eckit/models/store.dart';
import 'package:eckit/models/supplier.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../const.dart';

class SuppliersServices{

  static Future<List<Supplier>> getSuppliers(String currentPage) async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response = await dio.get("$baseUrl/suppliers?page=$currentPage");
        print(response);
        List<Supplier> temp = [];
        response.data["data"].forEach((post) => temp.add(Supplier.fromJson(post)));
        return temp;
      } catch (e) {
        print(e);
      }
      return null;
  }

  static Future<List<Supplier>> getAllSuppliers() async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response = await dio.get("$baseUrl/suppliers/all");
        print(response);
        List<Supplier> temp = [];
        response.data.forEach((post) => temp.add(Supplier.fromJson(post)));
        return temp;
      } catch (e) {
        print(e);
      }
      return null;
  }

    static Future<Supplier> savSupplier({String name,String notes, String id}) async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response = await dio.post(id != null ? "$baseUrl/suppliers/$id" : "$baseUrl/suppliers",data: {
          "name" : name,
          "notes" : notes,
        });

        Supplier temp;

        temp = Supplier.fromJson(response.data);

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