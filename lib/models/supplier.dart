class Supplier {
  int id;
  String name;
  String notes;
  int shopId;
  double balance;
  String createdAt;
  String updatedAt;

  Supplier(
      {this.id,
      this.name,
      this.notes,
      this.shopId,
      this.balance,
      this.createdAt,
      this.updatedAt});

  Supplier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    notes = json['notes'];
    shopId = json['shop_id'];
    balance = double.parse(json['balance'] == null ? "0" :json['balance'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['notes'] = this.notes;
    data['shop_id'] = this.shopId;
    data['balance'] = this.balance;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}