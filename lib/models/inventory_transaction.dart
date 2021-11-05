import './store.dart';
import './product.dart';

class InventoryTransaction {
  
  int id;
  String status;
  Product product;
  String type;
  int quantity;
  Store fromInventroy;
  Store toInventroy;
  int shopId;
  String createdAt;
  String updatedAt;

  InventoryTransaction(
      {this.id,
      this.status,
      this.product,
      this.type,
      this.quantity,
      this.fromInventroy,
      this.toInventroy,
      this.shopId,
      this.createdAt,
      this.updatedAt});

  InventoryTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    type = json['type'];
    quantity = json['quantity'];
    fromInventroy = json['from_inventroy'] != null
        ? new Store.fromJson(json['from_inventroy'])
        : null;
    toInventroy = json['to_inventroy'] != null
        ? new Store.fromJson(json['to_inventroy'])
        : null;
    shopId = json['shop_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    data['type'] = this.type;
    data['quantity'] = this.quantity;
    if (this.fromInventroy != null) {
      data['from_inventroy'] = this.fromInventroy.toJson();
    }
    if (this.toInventroy != null) {
      data['to_inventroy'] = this.toInventroy.toJson();
    }
    data['shop_id'] = this.shopId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}