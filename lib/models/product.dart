import 'Attribute.dart';
import 'image.dart';
import 'category.dart';

class Product {
  int id;
  String name;
  String description;
  double price;
  double cost;
  String unitType;
  int categoryId;
  bool isActive;
  List<Images> images;
  Category category;
  String currency;
  int index;
  double priceAfterDiscount;
  bool stockStatus;
  List<Attribute> attributes;

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
      this.currency,
      this.index,
      this.priceAfterDiscount,
      this.attributes,
      this.stockStatus});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'] == null ? 0.0 : json['price'].toDouble() ;
    cost = json['cost'] == null ? 0.0 : json['cost'].toDouble() ;
    unitType = json['unit_type'];
    categoryId = json['category_id'];
    isActive = json['is_active'] == 0 ? false : true;

    stockStatus = json['stock_status'] == 0 ? false : true;
    priceAfterDiscount = json['price_after_discount'] == null ? null : json['price_after_discount'].toDouble() ;
    index = int.parse(json['index'].toString());
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;

    if (json['attributes'] != null) {
      attributes = new List<Attribute>();
      json['attributes'].forEach((v) {
        attributes.add(new Attribute.fromJson(v));
      });
    }

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

    data['stock_status'] = this.stockStatus;
    data['price_after_discount'] = this.priceAfterDiscount;
    data['index'] = this.index;

    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }

    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }

    if (this.category != null) {
      data['category'] = this.category.toJson();
    }

    
    data['currency'] = this.currency;
    return data;
  }
}
