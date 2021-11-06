import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/models/cost.dart';
import 'package:eckit/models/order.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';

class CostServices {
  static Future<Cost> updateSatus({String costId, String newStatus}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      Response response = await dio.post(
        "$baseUrl/costs/$costId",
        data: {
          "status": newStatus,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status < 600;
          },
        ),
      );

      return Cost.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<List<Order>> getOrders(
    String currentPage,
    String keyword,
    String customerID,
    bool neworder,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));
    print(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      Response response;
      if (neworder) {
        response = await dio.get("$baseUrl/neworders/?page=$currentPage");
      } else if (keyword == null && customerID == null) {
        response = await dio.get("$baseUrl/orders/?page=$currentPage");
      } else if (keyword != null && customerID == null) {
        response = await dio.get("$baseUrl/orders/$keyword?page=$currentPage");
      } else if (keyword == null && customerID != null) {
        response = await dio.get("$baseUrl/orders/customer/$customerID?page=$currentPage");
      }

      List<Order> temp = [];
      print(response.data);
      response.data["data"].forEach((post) => temp.add(Order.fromJson(post)));
      return temp;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<List<Cost>> getCostsReport(
    String currentPage, {
    String startAt,
    String endAt,
    String type,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));
    print(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      Response response;
      String url = "$baseUrl/costs?page=$currentPage";

      if (type != null) {
        url = url + "&type=$type";
      }

      if (startAt != null) {
        url = url + "&start_at=$startAt";
      }

      if (endAt != null) {
        url = url + "&end_at=$endAt";
      }

      response = await dio.get(url);

      List<Cost> temp = [];
      print(response.data);
      response.data["data"].forEach((post) => temp.add(Cost.fromJson(post)));
      return temp;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  static Future<String> gerCostsTotal(String currentPage, {String startAt, String endAt, String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));
    print(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      Response response;
      String url = "$baseUrl/costs/total?page=$currentPage";

      if (type != null) {
        url = url + "&recipient_id=$type";
      }

      if (startAt != null) {
        url = url + "&start_at=$startAt";
      }

      if (endAt != null) {
        url = url + "&end_at=$endAt";
      }

      response = await dio.get(url);

      return response.data;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<Cost> createCost({String amount, String notes, String type, context, String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      Response response = await dio.post(
        "$baseUrl/costs",
        data: {
          "amount": amount,
          "type": type,
          "notes": notes,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status < 600;
          },
        ),
      );

      Navigator.pop(context);
      Navigator.pushNamed(context, '/costs_reports', arguments: {
        "startAt": null,
        "endAt": null,
        "type": null,
      });

      return Cost.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
