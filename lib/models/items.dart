import 'product.dart';

class Items {
  int id;
  double price;
  double cost;
  double quantity;
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
    price = json['price'] == null ? 0.0 : double.parse( json['price'].toString()) ;
    cost = json['cost'] == null ? 0.0 : double.parse( json['cost'].toString()) ;
    quantity = json['quantity'].toDouble() ;
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
