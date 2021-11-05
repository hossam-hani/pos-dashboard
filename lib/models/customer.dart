class Customer {
  int id;
  String name;
  String phoneNumber;
  List<Addresses> addresses;
  String createdAt;
  String updatedAt;
  String balance;
  

  Customer(
      {this.id,
      this.name,
      this.phoneNumber,
      this.addresses,
      this.createdAt,
      this.updatedAt,
      this.balance});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    if (json['addresses'] != null) {
      addresses = new List<Addresses>();
      json['addresses'].forEach((v) {
        addresses.add(new Addresses.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    balance = json['balance'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    if (this.addresses != null) {
      data['addresses'] = this.addresses.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['balance'] = this.balance;
    return data;
  }
}

class Addresses {
  int id;
  String address;
  int customerId;
  String createdAt;
  String updatedAt;

  Addresses(
      {this.id, this.address, this.customerId, this.createdAt, this.updatedAt});

  Addresses.fromJson(Map<String, dynamic> json) {
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