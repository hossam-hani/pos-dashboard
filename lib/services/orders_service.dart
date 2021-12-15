import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:eckit/models/account.dart';
import 'package:eckit/models/order.dart';

import '../const.dart';

class GraphDataForSalesAndCosts {
  List<num> sales;
  List<num> costs;

  GraphDataForSalesAndCosts({this.sales, this.costs});

  GraphDataForSalesAndCosts.fromJson(Map<String, dynamic> json) {
    sales = json['sales'].cast<num>();
    costs = json['costs'].cast<num>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sales'] = this.sales;
    data['costs'] = this.costs;
    return data;
  }
}

class OrderServices {
  static Future<GraphDataForSalesAndCosts> getGraphData(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));
    print(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      Response response = await dio.get("$baseUrl/graph/$type");
      GraphDataForSalesAndCosts temp = GraphDataForSalesAndCosts.fromJson(response.data);

      return temp;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<void> createSupplierInvoice({String items, String supplierId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    try {
      final dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      final data = {
        "shop_id": currentUser.shop.id.toString(),
        "items": items,
        "supplier_id": supplierId,
      };
      final response = await dio.post(
        "$baseUrl/order",
        data: data,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => status < 500,
        ),
      );
      print(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<Order> updateSatus({String orderId, String newStatus}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      Response response = await dio.post(
        "$baseUrl/order/status/$orderId",
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

      return Order.fromJson(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<List<Order>> getOrders(String currentPage, String keyword, String customerID, bool neworder) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));
    print(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      Response response;
      if (neworder) {
        final url = "$baseUrl/neworders/?page=$currentPage";
        print(url);
        response = await dio.get(url);
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
      log(e.toString());
    }
    return null;
  }

  static Future<List<Order>> getOrdersReport(
    String currentPage, {
    String startAt,
    String endAt,
    String customerId,
    int supplierId,
    String userId,
    bool supplierInvoices,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));
    print(jsonDecode(prefs.getString("account")));

    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

      String url = "$baseUrl/orders/reports?page=$currentPage";

      if (supplierInvoices != null) {
        url = url + "&supplier_invoices=1";
      }

      if (supplierId != null) {
        url = url + "&supplier_id=$supplierId";
      }

      if (customerId != null) {
        url = url + "&recipient_id=$customerId";
      }

      if (startAt != null) {
        url = url + "&start_at=$startAt";
      }

      if (endAt != null) {
        url = url + "&end_at=$endAt";
      }

      if (userId != null) {
        url = url + "&user_id=$userId";
      }

      log(url);

      final response = await dio.get(url);

      final List<Order> orders = (response.data["data"] as List)
          .map(
            (post) => Order.fromJson(post),
          )
          .toList();
      return orders;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<String> gerOrdersTotalPrice(
    String currentPage, {
    String startAt,
    String endAt,
    String customerId,
    int supplierId,
    String userId,
    bool supplierInvoices,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));
    print(jsonDecode(prefs.getString("account")));

    try {
      final dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;
      String url = "$baseUrl/orders/reports/total?page=$currentPage";

      if (supplierInvoices != null) {
        url = url + "&supplier_invoices=1";
      }

      if (supplierId != null) {
        url = url + "&supplier_id=$supplierId";
      }

      if (customerId != null) {
        url = url + "&recipient_id=$customerId";
      }

      if (startAt != null) {
        url = url + "&start_at=$startAt";
      }

      if (endAt != null) {
        url = url + "&end_at=$endAt";
      }

      if (userId != null) {
        url = url + "&user_id=$userId";
      }

      log(url);

      final response = await dio.get(url);

      print(response);

      return response.data;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
