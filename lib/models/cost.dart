class Cost {
  int id;
  int amount;
  String type;
  String notes;
  int shopId;
  String createdAt;
  String updatedAt;

  Cost(
      {this.id,
      this.amount,
      this.type,
      this.notes,
      this.shopId,
      this.createdAt,
      this.updatedAt});

  Cost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    type = json['type'];
    notes = json['notes'];
    shopId = json['shop_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['notes'] = this.notes;
    data['shop_id'] = this.shopId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}