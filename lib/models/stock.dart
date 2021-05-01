import 'product.dart';
import 'store.dart';
import 'supplier.dart';

class Stock {
  int id;
  Product product;
  Store store;
  Supplier supplier;
  int shopId;
  double quantity;

  Stock(
      {this.id,
      this.product,
      this.store,
      this.supplier,
      this.shopId,
      this.quantity});

  Stock.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
    supplier = json['supplier'] != null
        ? new Supplier.fromJson(json['supplier'])
        : null;
    shopId = json['shop_id'];
    quantity = double.parse(json['quantity'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    if (this.store != null) {
      data['store'] = this.store.toJson();
    }
    if (this.supplier != null) {
      data['supplier'] = this.supplier.toJson();
    }
    data['shop_id'] = this.shopId;
    data['quantity'] = this.quantity;
    return data;
  }
}