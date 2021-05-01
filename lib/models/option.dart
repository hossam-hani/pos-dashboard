
class Option {
  int id;
  int attributeId;
  String title;
  String description;
  double addedPrice;
  bool stockStatus;
  String createdAt;
  String updatedAt;

  Option(
      {this.id,
      this.attributeId,
      this.title,
      this.description,
      this.addedPrice,
      this.stockStatus,
      this.createdAt,
      this.updatedAt});


    set setTitle(String newTitle) {
      this.title = newTitle;
    }  

    set setDescription(String newDes) {
      this.description = newDes;
    }  

    set setAddedPrice(String newAddedPrices) {
      this.addedPrice = double.parse(newAddedPrices);
    }  

    set setNewStockStatus(bool newStockStatus) {
      this.stockStatus = newStockStatus;
    }  


  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeId = json['attribute_id'];
    title = json['title'];
    description = json['description'];
    addedPrice = double.parse(json['added_price'].toString());
    stockStatus = json['stock_status'] == 0 ? false : true;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['attribute_id'] = this.attributeId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['added_price'] = this.addedPrice;
    data['stock_status'] = this.stockStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}