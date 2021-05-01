
import 'supplier.dart';
import 'customer.dart';

class Transaction {
  int id;
  double amount;
  int shopId;
  int userId;
  String recipientId;
  String type;
  String recipientType;
  Customer customer;
  Supplier supplier;
  String reason;
  String createdAt;
  String updatedAt;

  Transaction(
      {this.id,
      this.amount,
      this.shopId,
      this.userId,
      this.recipientId,
      this.type,
      this.recipientType,
      this.customer,
      this.supplier,
      this.reason,
      this.createdAt,
      this.updatedAt});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = double.parse(json['amount'].toString());
    shopId = json['shop_id'];
    userId = json['user_id'];
    recipientId = json['recipient_id'];
    type = json['type'];
    recipientType = json['recipient_type'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    supplier = json['supplier'] != null
        ? new Supplier.fromJson(json['supplier'])
        : null;
    reason = json['reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['shop_id'] = this.shopId;
    data['user_id'] = this.userId;
    data['recipient_id'] = this.recipientId;
    data['type'] = this.type;
    data['recipient_type'] = this.recipientType;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    if (this.supplier != null) {
      data['supplier'] = this.supplier.toJson();
    }
    data['reason'] = this.reason;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}