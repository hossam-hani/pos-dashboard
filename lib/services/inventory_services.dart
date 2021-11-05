


import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/models/category.dart';
import 'package:eckit/models/inventory_transaction.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../const.dart';

class InventoryServices{

  
    static Future<List> getQuantities({String inventroyId,String amount,String type}) async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;


    try {

      Response response = await dio.get("$baseUrl/inventroytranscations/inventroy/$inventroyId");
      return json.decode(response.data.toString());   
      
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<List<InventoryTransaction>> getInventroyTreanscations(String currentPage) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      try {
        Response response = await dio.get("$baseUrl/inventroytranscations?page=$currentPage");

        List<InventoryTransaction> temp = [];
        response.data["data"].forEach((post) => temp.add(InventoryTransaction.fromJson(post)));
        return temp;
        
      } catch (e) {
        print(e);
      }

      return null;
  }
  
  static Future<void> acceptInventoryTranscation(String id) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      try {
        Response response = await dio.post("$baseUrl/inventroytranscations/approve/$id");

        return response;
        
      } catch (e) {
        print(e);
      }

      return null;
  }

  static Future<void> createTranscations({String quantity,String type,int from,int to,String productId,context}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      var data = {
          "status" : "waiting",
          "type" : type,
          "quantity" : quantity,
          "from_inventroy" : from.toString(),
          "product_id" : productId,
      };

      if(type == "transfer"){
        data["to_inventroy"] = to.toString();
      }

      try {
        Response response = await dio.post("$baseUrl/inventroytranscations",data: data);
        Navigator.pop(context);
        Navigator.pushNamed(context, '/inventory_transactions');
        return response;
        
      } catch (e) {
        print(e);
      }

      return null;
  }

  

}