class Store {
  int id;
  String name;
  int shopId;
  String createdAt;
  String updatedAt;

  Store({this.id, this.name, this.shopId, this.createdAt, this.updatedAt});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shopId = json['shop_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['shop_id'] = this.shopId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
