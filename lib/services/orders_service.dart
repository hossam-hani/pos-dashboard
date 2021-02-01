

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';


class OrderServices{

  
  
  static Future<Order> updateSatus({String orderId, String newStatus}) async {
        
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      Response response = await dio.post("$baseUrl/order/status/$orderId",data: {
        "status" : newStatus,
      },  options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 600;
            },
        ),);
      
      return Order.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<List<Order>> getOrders(String currentPage,String keyword,String customerID,bool neworder) async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response ;
        if(neworder){
          response = await dio.get("$baseUrl/neworders/?page=$currentPage");
        }else if(keyword == null && customerID == null){
           response = await dio.get("$baseUrl/orders/?page=$currentPage");
        }else if(keyword != null && customerID == null){
           response = await dio.get("$baseUrl/orders/$keyword?page=$currentPage");
        }else if(keyword == null && customerID != null){
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
}