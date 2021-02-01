class BootData {
  String websiteLink;
  String registrationRules;
  List<Categories> categories;
  List<Countries> countries;

  BootData(
      {this.websiteLink,
      this.registrationRules,
      this.categories,
      this.countries});

  BootData.fromJson(Map<String, dynamic> json) {
    websiteLink = json['website_link'];
    registrationRules = json['registration_rules'];
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['countries'] != null) {
      countries = new List<Countries>();
      json['countries'].forEach((v) {
        countries.add(new Countries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['website_link'] = this.websiteLink;
    data['registration_rules'] = this.registrationRules;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.countries != null) {
      data['countries'] = this.countries.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String title;
  String key;
  String imageUrl;
  String description;

  Categories({this.title, this.key, this.imageUrl, this.description});

  Categories.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    key = json['key'];
    imageUrl = json['image_url'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['key'] = this.key;
    data['image_url'] = this.imageUrl;
    data['description'] = this.description;
    return data;
  }
}

class Countries {
  String country;
  String currency;
  String countryName;
  String code;
  String flagImg;

  Countries(
      {this.country, this.currency, this.countryName, this.code, this.flagImg});

  Countries.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    currency = json['currency'];
    countryName = json['country_name'];
    code = json['code'];
    flagImg = json['flag_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['currency'] = this.currency;
    data['country_name'] = this.countryName;
    data['code'] = this.code;
    data['flag_img'] = this.flagImg;
    return data;
  }
}