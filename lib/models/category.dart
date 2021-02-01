class Category {
  int id;
  String name;
  String description;
  String image;
  bool isActive;
  int shopId;
  String createdAt;
  String updatedAt;

  Category(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.isActive,
      this.shopId,
      this.createdAt,
      this.updatedAt});

  @override
  // ignore: hash_and_equals
  bool operator == (other) {
    return other.id == this.id;
  }


  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    isActive = json['is_active'] == 0 ? false : true;
    shopId = json['shop_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    data['shop_id'] = this.shopId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}