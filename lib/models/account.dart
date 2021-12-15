class Account {
  User user;
  Shop shop;
  String accessToken;

  Account({this.user, this.shop, this.accessToken});

  Account.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    data['access_token'] = this.accessToken;
    return data;
  }
}

class User {
  String name;
  String email;
  String phone;
  bool isBlocked;
  int shopId;
  String updatedAt;
  String createdAt;
  String role;

  int id;

  User(
      {this.name,
      this.email,
      this.phone,
      this.isBlocked,
      this.shopId,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.role});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    isBlocked = json['is_blocked'] == "1" ? true : false;
    shopId = json['shop_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['is_blocked'] = this.isBlocked ? "1" : "0";
    data['shop_id'] = this.shopId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['role'] = this.role;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.isBlocked == isBlocked &&
        other.shopId == shopId &&
        other.updatedAt == updatedAt &&
        other.createdAt == createdAt &&
        other.role == role &&
        other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        isBlocked.hashCode ^
        shopId.hashCode ^
        updatedAt.hashCode ^
        createdAt.hashCode ^
        role.hashCode ^
        id.hashCode;
  }
}

class Shop {
  int id;
  String name;
  String link;
  String whatsappContact;
  String phoneNumber;
  String facebookLink;
  String instagramLink;
  String logo;
  String description;
  String category;
  String currency;
  String country;
  int isFinishedTrial;
  int isPaidAccount;
  int isBlocked;
  String expDate;
  String createdAt;
  String updatedAt;
  String sliderimage1;
  String sliderimage2;
  String sliderimage3;
  String sliderimage4;
  String sliderimage5;
  String gaId;
  String pixelId;

  bool isActive;

  Shop(
      {this.id,
      this.name,
      this.link,
      this.whatsappContact,
      this.phoneNumber,
      this.facebookLink,
      this.instagramLink,
      this.logo,
      this.description,
      this.category,
      this.currency,
      this.country,
      this.isFinishedTrial,
      this.isPaidAccount,
      this.isBlocked,
      this.expDate,
      this.createdAt,
      this.updatedAt,
      this.sliderimage1,
      this.sliderimage2,
      this.sliderimage3,
      this.sliderimage4,
      this.sliderimage5,
      this.isActive,
      this.gaId,
      this.pixelId});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    link = json['link'];
    whatsappContact = json['whatsapp_contact'];
    phoneNumber = json['phone_number'];
    facebookLink = json['facebook_link'];
    instagramLink = json['instagram_link'];
    logo = json['logo'];
    description = json['description'];
    category = json['category'];
    currency = json['currency'];
    country = json['country'];
    isFinishedTrial = json['is_finished_trial'];
    isPaidAccount = json['is_paid_account'];
    isBlocked = json['is_blocked'];
    expDate = json['exp_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sliderimage1 = json['sliderimage_1'];
    sliderimage2 = json['sliderimage_2'];
    sliderimage3 = json['sliderimage_3'];
    sliderimage4 = json['sliderimage_4'];
    sliderimage5 = json['sliderimage_5'];
    gaId = json['ga_id'];
    pixelId = json['pixel_id'];
    isActive = json['is_active'] == 0 ? false : true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['link'] = this.link;
    data['whatsapp_contact'] = this.whatsappContact;
    data['phone_number'] = this.phoneNumber;
    data['facebook_link'] = this.facebookLink;
    data['instagram_link'] = this.instagramLink;
    data['logo'] = this.logo;
    data['description'] = this.description;
    data['category'] = this.category;
    data['currency'] = this.currency;
    data['country'] = this.country;
    data['is_finished_trial'] = this.isFinishedTrial;
    data['is_paid_account'] = this.isPaidAccount;
    data['is_blocked'] = this.isBlocked;
    data['exp_date'] = this.expDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['sliderimage_1'] = this.sliderimage1;
    data['sliderimage_2'] = this.sliderimage2;
    data['sliderimage_3'] = this.sliderimage3;
    data['sliderimage_4'] = this.sliderimage4;
    data['sliderimage_5'] = this.sliderimage5;
    data['ga_id'] = this.gaId;
    data['pixel_id'] = this.pixelId;
    data['is_active'] = this.isActive;
    return data;
  }
}
