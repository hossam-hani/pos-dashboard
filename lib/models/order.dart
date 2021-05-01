import 'customer.dart';
import 'address.dart';
import 'items.dart';

class Order {
  int id;
  String currency;
  double total;
  String status;
  Customer customer;
  Address address;
  List<Items> items;
  String channel;
  String createdAt;
  String updatedAt;

  Order(
      {this.id,
      this.currency,
      this.total,
      this.status,
      this.customer,
      this.address,
      this.items,
      this.channel,
      this.createdAt,
      this.updatedAt});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currency = json['currency'];
    total = json['total'] == null ? 0.0 : double.parse( json['total'].toString()) ;
    status = json['status'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
        
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }

    channel = json['channel'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['currency'] = this.currency;
    data['total'] = this.total;
    data['status'] = this.status;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    
    data['channel'] = this.channel;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}