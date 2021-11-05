

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/models/order.dart';
import 'package:eckit/models/visit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';


class VisitsServices{

    static Future<List<Visit>> getVisitsReport(String currentPage
    ,{String startAt, String endAt,String customerId,String userId}) async {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));
      print(jsonDecode(prefs.getString("account")));

      try {
        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

        Response response ;
        String url = "$baseUrl/vstists?page=$currentPage";

        if(userId != null){
          url = url + "&user_id=$userId";
        }
        
        if(customerId != null){
          url = url + "&customer_id=$customerId";
        }

        if(startAt != null){
          url = url + "&start_at=$startAt";
        }

        if(endAt != null){
          url = url + "&end_at=$endAt";
        }

        response = await dio.get(url);

        List<Visit> temp = [];
        print(response.data);
        response.data["data"].forEach((post) => temp.add(Visit.fromJson(post)));
        return temp;
        
      } catch (e) {
        print(e);
      }
      return null;
  }

  
}


