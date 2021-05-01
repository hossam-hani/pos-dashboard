


import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/models/region.dart';
import 'package:eckit/models/stock.dart';
import 'package:eckit/models/store.dart';
import 'package:eckit/models/supplier.dart';
import 'package:eckit/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../const.dart';

class TransactionsServices{

  static Future<List<Transaction>> getTransactions(String currentPage) async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response = await dio.get("$baseUrl/transactions?page=$currentPage");
        print(response);
        List<Transaction> temp = [];
        response.data["data"].forEach((post) => temp.add(Transaction.fromJson(post)));
        return temp;
      } catch (e) {
        print(e);
      }
      return null;
  }



  static Future<Transaction> saveTransaction({String amount,String recipientId,String recipientType, String type, String reason, String id}) async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response = await dio.post(id != null ? "$baseUrl/transactions/$id" : "$baseUrl/transactions",data: 
        {
          "amount" : amount,
          "recipient_id" : recipientId,
          "recipient_type" : recipientType,
          "type" : type,
          "reason" : reason
        });

        Transaction temp;
        temp = Transaction.fromJson(response.data);

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