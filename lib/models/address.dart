class Address {
  int id;
  String address;
  int customerId;
  String createdAt;
  String updatedAt;

  Address(
      {this.id, this.address, this.customerId, this.createdAt, this.updatedAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    customerId = json['customer_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['customer_id'] = this.customerId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
