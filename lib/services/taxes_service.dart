import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/models/region.dart';
import 'package:eckit/models/store.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../const.dart';

class TaxesService {
  static Future<Taxes> getTaxes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      Response response = await dio.get("$baseUrl/taxes");

      return Taxes.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<void> saveTaxes(
      {String tax1Title,
      String tax1Amount,
      String tax2Title,
      String tax2Amount,
      String tax3Title,
      String tax3Amount}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    try {
      final dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      final data = {
        "tax1_title": tax1Title,
        "tax1_amount": tax1Amount,
        "tax2_title": tax2Title,
        "tax2_amount": tax2Amount,
        "tax3_title": tax3Title,
        "tax3_amount": tax3Amount,
      };
      final response = await dio.post("$baseUrl/taxes/update", data: data);

      return response.data;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

class Taxes {
  String tax1Title;
  double tax1Amount;
  String tax2Title;
  double tax2Amount;
  String tax3Title;
  double tax3Amount;

  Taxes({this.tax1Title, this.tax1Amount, this.tax2Title, this.tax2Amount, this.tax3Title, this.tax3Amount});

  Taxes.fromJson(Map<String, dynamic> json) {
    tax1Title = json['tax1_title'];
    tax1Amount = json['tax1_amount'];
    tax2Title = json['tax2_title'];
    tax2Amount = json['tax2_amount'];
    tax3Title = json['tax3_title'];
    tax3Amount = json['tax3_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tax1_title'] = this.tax1Title;
    data['tax1_amount'] = this.tax1Amount;
    data['tax2_title'] = this.tax2Title;
    data['tax2_amount'] = this.tax2Amount;
    data['tax3_title'] = this.tax3Title;
    data['tax3_amount'] = this.tax3Amount;
    return data;
  }
}
