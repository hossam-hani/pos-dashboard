


import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/models/category.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../const.dart';

class CategoryServices{

  static Future<List<Category>> getCategories(String currentPage) async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response = await dio.get("$baseUrl/categories?page=$currentPage");
        print(response);
        List<Category> temp = [];
        response.data["data"].forEach((post) => temp.add(Category.fromJson(post)));
        return temp;
      } catch (e) {
        print(e);
      }
      return null;
  }

  static Future<List<Category>> getAllCategories() async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response = await dio.get("$baseUrl/categories");
        print(response);
        List<Category> temp = [];
        response.data["data"].forEach((post) => temp.add(Category.fromJson(post)));
        return temp;
      } catch (e) {
        print(e);
      }
      return null;
  }

    static Future<Category> saveCategory({String name,String description, bool isActive, String image, String id}) async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response = await dio.post(id != null ? "$baseUrl/categories/$id" : "$baseUrl/categories",data: 
        image != null ? {
          "name" : name,
          "is_active" : isActive,
          "description" : description,
          "image" : image
        } : {
          "name" : name,
          "is_active" : isActive,
          "description" : description,
        });

        Category temp;
        temp = Category.fromJson(response.data);
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