


import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/models/region.dart';
import 'package:eckit/models/stock.dart';
import 'package:eckit/models/store.dart';
import 'package:eckit/models/supplier.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../const.dart';

class StocksServices{

  static Future<List<Stock>> getStocks(String currentPage) async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response = await dio.get("$baseUrl/stocks?page=$currentPage");
        print(response);
        List<Stock> temp = [];
        response.data["data"].forEach((post) => temp.add(Stock.fromJson(post)));
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

        Response response = await dio.get("$baseUrl/stores/all");
        print(response);
        List<Region> temp = [];
        response.data.forEach((post) => temp.add(Region.fromJson(post)));
        return temp;
      } catch (e) {
        print(e);
      }
      return null;
  }


  static Future<Stock> saveStock({String productId,String storeId, String quantity, String supplierId, String id}) async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        print({
          "product_id" : productId,
          "store_id" : storeId,
          "supplier_id" : supplierId,
          "quantity" : quantity
        });
        Response response = await dio.post(id != null ? "$baseUrl/stocks/$id" : "$baseUrl/stocks",data: 
        {
          "product_id" : productId,
          "store_id" : storeId,
          "supplier_id" : supplierId,
          "quantity" : quantity
        });

        Stock temp;
        temp = Stock.fromJson(response.data);

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