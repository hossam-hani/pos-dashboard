

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/models/product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductServices{

  static Future<List<Product>> getProducts(String currentPage) async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response = await dio.get("$baseUrl/products?page=$currentPage");
        List<Product> temp = [];
        response.data["data"].forEach((post) => temp.add(Product.fromJson(post)));
        return temp;
      } catch (e) {
        print(e);
      }
      return null;
  }

    static Future<Product> saveProduct({String name,String description
    , bool isActive, List<String> images, String id,
    String categoryId,double price,double cost,
    String unitType,double priceAfterDiscount
    , bool stockStatus, int index}) async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response = await dio.post(id != null ? "$baseUrl/products/$id" : "$baseUrl/products" ,data: 
        images != null ? {
          "name" : name,
          "price" : price,
          "cost" : cost,
          "category_id" : categoryId,
          "is_active" : isActive,
          "description" : description,
          "unit_type" : unitType,
          "images" : jsonEncode(images),
          "index" : index,
          "stock_status" : stockStatus,
          "price_after_discount" : priceAfterDiscount,
        } : {
          "name" : name,
          "price" : price,
          "cost" : cost,
          "category_id" : categoryId,
          "is_active" : isActive,
          "unit_type" : unitType,
          "description" : description,
          "index" : index,
          "stock_status" : stockStatus,
          "price_after_discount" : priceAfterDiscount,
        },  options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 600;
            },
        ),);

        Product temp;
        print(response.data);
        // temp = Product.fromJson(response.data);
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