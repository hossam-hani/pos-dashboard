class NotificationModel {
  int id;
  String subject;
  String img;
  String message;
  int receiverId;
  int shopId;
  String createdAt;
  String updatedAt;

  NotificationModel(
      {this.id,
      this.subject,
      this.img,
      this.message,
      this.receiverId,
      this.shopId,
      this.createdAt,
      this.updatedAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    img = json['img'];
    message = json['message'];
    receiverId = json['receiver_id'];
    shopId = json['shop_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['img'] = this.img;
    data['message'] = this.message;
    data['receiver_id'] = this.receiverId;
    data['shop_id'] = this.shopId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}