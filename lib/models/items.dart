import 'product.dart';

class Items {
  int id;
  int price;
  int cost;
  int quantity;
  String notes;
  Product product;

  Items(
      {this.id,
      this.price,
      this.cost,
      this.quantity,
      this.notes,
      this.product});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    cost = json['cost'];
    quantity = json['quantity'];
    notes = json['notes'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['cost'] = this.cost;
    data['quantity'] = this.quantity;
    data['notes'] = this.notes;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}
