import 'account.dart';
import 'customer.dart';
import 'address.dart';
import 'items.dart';
import 'supplier.dart';

class Order {
  int id;
  String currency;
  double total;
  String status;
  Customer customer;
  Address address;
  List<Items> items;
  String channel;
  String createdAt;
  String updatedAt;
  Supplier supplier;
  String tax1;
  double tax1Amount;
  String tax2;
  double tax2Amount;
  String tax3;
  double tax3Amount;
  int taxId;
  String invoiceId;
  User user;


  Order(
      {this.id,
      this.currency,
      this.total,
      this.status,
      this.customer,
      this.address,
      this.items,
      this.channel,
      this.createdAt,
      this.updatedAt,
      this.supplier,
      this.tax1,
      this.tax1Amount,
      this.tax2,
      this.tax2Amount,
      this.tax3,
      this.tax3Amount,
      this.taxId,
      this.invoiceId,
      this.user});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currency = json['currency'];
    total = json['total'] == null ? 0.0 : double.parse( json['total'].toString()) ;
    status = json['status'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    user = json['user'] != null
        ? new User.fromJson(json['user'])
        : null;
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
        
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    supplier = json['supplier'] != null
        ? new Supplier.fromJson(json['supplier'])
        : null;
    channel = json['channel'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    tax1 = json['tax1'];
    tax1Amount = json['tax1_amount'];
    tax2 = json['tax2'];
    tax2Amount = json['tax2_amount'];
    tax3 = json['tax3'];
    tax3Amount = json['tax3_amount'];
    taxId = json['tax_id'];
    invoiceId = json['invoice_id'];    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['currency'] = this.currency;
    data['total'] = this.total;
    data['status'] = this.status;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    if (this.supplier != null) {
      data['supplier'] = this.supplier.toJson();
    }
    data['channel'] = this.channel;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;

    data['tax1'] = this.tax1;
    data['tax1_amount'] = this.tax1Amount;
    data['tax2'] = this.tax2;
    data['tax2_amount'] = this.tax2Amount;
    data['tax3'] = this.tax3;
    data['tax3_amount'] = this.tax3Amount;
    data['tax_id'] = this.taxId;
    data['invoice_id'] = this.invoiceId;

    return data;
  }
}