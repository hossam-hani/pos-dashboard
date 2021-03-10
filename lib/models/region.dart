class Region {
  int id;
  String name;
  double fees;
  String regionId;
  bool isActive;
  String shopId;
  String createdAt;
  String updatedAt;

  Region(
      {this.id,
      this.name,
      this.fees,
      this.regionId,
      this.isActive,
      this.shopId,
      this.createdAt,
      this.updatedAt});


  @override
  // ignore: hash_and_equals
  bool operator == (other) {
    return other.id == this.id;
  }


  Region.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fees = json['fees'] != null ? double.parse(json['fees'].toString()) : null;
    regionId = json['region_id'] == null ? null : json['region_id'].toString();
    isActive = json['is_active'] == 0 ? false : true;
    shopId = json['shop_id'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['fees'] = this.fees;
    data['region_id'] = this.regionId;
    data['is_active'] = this.isActive;
    data['shop_id'] = this.shopId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}