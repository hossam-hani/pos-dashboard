import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';
import '../models/account.dart';

class AccountService{

  static Future<Account> createAccount({String storeName, String link, String currency
  ,String country,String name,String email,String phone,String password,String category}) async {
    try {

      Response response = await Dio().post("$baseUrl/user/register",data: {
        "store_name" : storeName,
        "link" : link,
        "currency" : currency,
        "country" : country,
        "name" : name,
        "email" : email,
        "phone" : phone,
        "password" : password,
        "category" : category,
      },  options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 600;
            },
        ),);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("account", jsonEncode(response.data));
      prefs.setBool("isRegisterd", true);

      return Account.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }



  static Future<Account> login({String email, String password}) async {
    try {

      Response response = await Dio().post("$baseUrl/user/login",data: {
        "email" : email,
        "password" : password,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("account", jsonEncode(response.data));
      
      return Account.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

    static Future<void> addTokenToUser({String token}) async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

        Dio dio = new Dio();
        dio.options.headers['content-Type'] = 'application/json';
        dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;


    try {

      Response response = await dio.post("$baseUrl/user/token",data: {
        "token" : token,
      });

   
      
    } catch (e) {
      print(e);
    }
    return null;
  }

  
  
}