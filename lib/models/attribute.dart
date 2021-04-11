import './option.dart';

class Attribute {
  int id;

  String title;
  String type;
  bool isRequired;
  List<Option> options;
  String createdAt;
  String updatedAt;

  Attribute(
      {this.id,
      this.title,
      this.type,
      this.isRequired,
      this.options,
      this.createdAt,
      this.updatedAt});


    set setTitle(String newTitle) {
      this.title = newTitle;
    }  

    set setType(String newType) {
      this.type = newType;
    }  

    set setIsRequired(bool newStatusOfRequired) {
      print(newStatusOfRequired);
      this.isRequired = newStatusOfRequired;
    }  

    addOption(){
      options.add(Option(stockStatus: true));
      print("test");
    }

    removeOption(int index){
      options.removeAt(index);
    }

  Attribute.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    title = json['title'];
    type = json['type'];
    isRequired = json['isRequired'] == 0 ? false : true;
    if (json['options'] != null) {
      options = new List<Option>();
      json['options'].forEach((v) {
        options.add(new Option.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    data['isRequired'] = this.isRequired;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}