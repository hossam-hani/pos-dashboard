import 'package:eckit/components/date_range_picker.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/models/address.dart';
import 'package:eckit/models/customer.dart';
import 'package:eckit/models/items.dart';
import 'package:eckit/models/order.dart';
import 'package:eckit/models/supplier.dart';
import 'package:eckit/models/transaction.dart';
import 'package:eckit/services/account_service.dart';
import 'package:eckit/services/customer_service.dart';
import 'package:eckit/services/orders_service.dart';
import 'package:eckit/services/suppliers_service.dart';
import 'package:eckit/services/transactions_service.dart';
import 'package:eckit/utilties/time_formater.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../components/customeButton.dart';
import 'package:paging/paging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../const.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class SuppliersInvoicesReport extends StatefulWidget {
  final String supplierId;
  final String startAt;
  final String endAt;
  final String userId;

  SuppliersInvoicesReport({
    this.supplierId,
    this.startAt,
    this.endAt,
    this.userId,
  });

  @override
  _SuppliersInvoicesReportListState createState() => _SuppliersInvoicesReportListState();
}

class _SuppliersInvoicesReportListState extends State<SuppliersInvoicesReport> {
  List<Order> orders = [];
  int currentPage = 1;
  bool isLoading = false;
  TextEditingController keyword = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String totalBalance = '0';

  DateTime startFrom;
  DateTime endAt;
  Supplier supplier;

  List<Supplier> suppliers;

  var loadingKit = Center(
    child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        SpinKitSquareCircle(
          color: mainColor,
          size: 50.0,
        ),
        SizedBox(
          height: 10,
        ),
        Text("loading".tr())
      ],
    ),
  );

  Future<List<Order>> getOrdersLocal() async {
    final _startAt = startFrom == null ? null : DateFormat('yyyy-MM-dd').format(startFrom);
    final _endAt = endAt == null ? null : DateFormat('yyyy-MM-dd').format(endAt);
    List<Order> temp = await OrderServices.getOrdersReport(
      currentPage.toString(),
      customerId: null,
      userId: null,
      supplierInvoices: true,
      supplierId: supplier?.id ?? widget.supplierId,
      startAt: _startAt ?? widget.startAt,
      endAt: _endAt ?? widget.endAt,
    );

    setState(() {
      orders = orders.isEmpty ? temp : orders;
      currentPage = currentPage + 1;
      isLoading = false;
    });

    return temp;
  }

  Future<void> getTotalForOrders() async {
    final _startAt = startFrom == null ? null : DateFormat('yyyy-MM-dd').format(startFrom);
    final _endAt = endAt == null ? null : DateFormat('yyyy-MM-dd').format(endAt);
    String valTemp = await OrderServices.gerOrdersTotalPrice(
      currentPage.toString(),
      customerId: null,
      userId: null,
      supplierInvoices: true,
      supplierId: supplier?.id ?? widget.supplierId,
      startAt: _startAt ?? widget.startAt,
      endAt: _endAt ?? widget.endAt,
    );

    List<Supplier> temp = await SuppliersServices.getAllSuppliers();

    setState(() {
      suppliers = temp;
      totalBalance = valTemp;
    });
  }

  @override
  void initState() {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    getTotalForOrders();

    super.initState();
    setState(() {
      isLoading = true;
    });
  }

  Future<void> _reloadData() async {
    setState(() {
      orders.clear();
      currentPage = 1;
      isLoading = false;
    });
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: FaIcon(FontAwesomeIcons.arrowRight, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Image.asset(
            "assets/images/logo.png",
            height: 40,
          )),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(FontAwesomeIcons.fileInvoiceDollar),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "?????????????????? ( ???????????? ???????????????? )".tr(),
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                Divider(),
                DateRangePicker(
                  from: startFrom,
                  to: endAt,
                  onChanged: (from, to) {
                    startFrom = from;
                    endAt = to;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                if (suppliers != null)
                  ListTile(
                    leading: Text("????????????"),
                    title: DropdownButton<Supplier>(
                      value: supplier,
                      isExpanded: true,
                      hint: Text("???????? ???????????? ???????? ???????? ???? ?????????? ??????????????"),
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (Supplier newValue) {
                        setState(() {
                          supplier = newValue;
                        });
                      },
                      items: suppliers.map<DropdownMenuItem<Supplier>>((Supplier supplier) {
                        return DropdownMenuItem<Supplier>(
                          value: supplier,
                          child: Text(supplier.name.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                CustomeButton(
                  handler: () => _reloadData(),
                  title: "confirm".tr(),
                ),
                ListTile(
                  title: Text("???????????? ???????????????? : ${totalBalance ?? "0"} EGP "),
                ),
                orders.isEmpty && !isLoading ? ProductPlaceholder() : SizedBox(),
                orders.isEmpty && !isLoading
                    ? SizedBox()
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Pagination(
                            progress: loadingKit,
                            pageBuilder: (currentListSize) => getOrdersLocal(),
                            itemBuilder: (index, Order order) => ListItem(
                              id: order.id.toString(),
                              supplierName: order.supplier.name,
                              date: order.createdAt,
                              total: order.total.toString(),
                              items: order.items,
                              // amount: order.amount.toString(),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomeTextField extends StatelessWidget {
  String hintTxt;
  String labelTxt;
  TextEditingController controller;
  dynamic validator;
  bool obscureTextbool;

  CustomeTextField({this.hintTxt, this.labelTxt, this.controller, this.validator, this.obscureTextbool = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureTextbool,
      validator: validator,
      controller: controller,
      decoration: new InputDecoration(
          hintText: hintTxt,
          labelText: labelTxt,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFECDFDF)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFECDFDF)),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFECDFDF)),
          )),
    );
  }
}

class ListItem extends StatelessWidget {
  String id;
  String supplierName;
  String total;
  String date;
  List<Items> items;

  ListItem({this.supplierName, this.id, this.total, this.date, this.items});
  @override
  Widget build(BuildContext context) {
    double cost = 0;

    items.forEach((e) {
      cost = cost + e.cost;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '?????? ???????????????? : #$id',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 18,
                    color: const Color(0xff8F8D8D),
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '?????? ???????????? : $supplierName',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  '?????????????? ???????????????? ',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 7,
                ),
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        children: [
                          Text(
                            "${item.product.name} | ${item.product.price} * ${item.quantity}",
                            style: TextStyle(fontFamily: 'lato'),
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 7,
                ),
                Text(
                  '???????? ???????????????? : $total ????????',
                  style: TextStyle(
                      fontSize: 18, color: const Color(0xff3a3a3a), fontWeight: FontWeight.w300, fontFamily: "Lato"),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 3,
                ),
                Divider(color: Colors.black),
                Text(
                  '?????????????? : ${formateStringTime(date)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'lato',
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            )
          ],
        ),
        Divider(color: Colors.black),
      ],
    );
  }
}

class ProductPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.users,
            size: 75,
            color: const Color(0xffe6d7d7),
          ),
          SizedBox(
            height: 12,
          ),
          Center(
            child: Text(
              'no_users'.tr(),
              style: TextStyle(
                fontSize: 25,
                color: const Color(0xffdbd3d3),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
