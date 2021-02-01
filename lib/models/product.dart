import 'image.dart';
import 'category.dart';

class Product {
  int id;
  String name;
  String description;
  int price;
  int cost;
  String unitType;
  int categoryId;
  bool isActive;
  List<Images> images;
  Category category;
  String currency;

  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.cost,
      this.unitType,
      this.categoryId,
      this.isActive,
      this.images,
      this.category,
      this.currency});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    cost = json['cost'];
    unitType = json['unit_type'];
    categoryId = json['category_id'];
    isActive = json['is_active'] == 0 ? false : true;
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['cost'] = this.cost;
    data['unit_type'] = this.unitType;
    data['category_id'] = this.categoryId;
    data['is_active'] = this.isActive;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['currency'] = this.currency;
    return data;
  }
}
