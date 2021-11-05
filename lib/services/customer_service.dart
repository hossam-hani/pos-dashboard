import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';

class CustomerServices{

    static Future<String> getCustomerBalance() async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response;

        response = await dio.get("$baseUrl/customers/balance/total");

        return response.data;

    }

    static Future<List<Customer>> getCustomers(String currentPage,String keyword) async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      if(keyword == "") return [];
      
      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response;
        
        if(keyword == null){
          response = await dio.get("$baseUrl/customers?page=$currentPage");
        }else {
          response = await dio.get("$baseUrl/customers/search/$keyword?page=$currentPage");
        }

        List<Customer> temp = [];
        response.data["data"].forEach((post) => temp.add(Customer.fromJson(post)));
        return temp;
      } catch (e) {
        print(e);
      }
      return null;
  }
}