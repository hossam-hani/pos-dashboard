import 'package:eckit/models/account.dart';
import 'package:eckit/models/customer.dart';

class Visit {
  int id;
  Customer customer;
  String startTime;
  String endTime;
  int shopId;
  User user;
  String createdAt;
  String updatedAt;

  Visit(
      {this.id,
      this.customer,
      this.startTime,
      this.endTime,
      this.shopId,
      this.user,
      this.createdAt,
      this.updatedAt});

  Visit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    startTime = json['start_time'];
    endTime = json['end_time'];
    shopId = json['shop_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['shop_id'] = this.shopId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}