import 'package:eckit/models/items.dart';
import 'package:eckit/models/order.dart';
import 'package:eckit/services/orders_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../components/customeButton.dart';
import 'package:paging/paging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product.dart';
import '../../const.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../validator.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrderList extends StatefulWidget {
  String keyword;
  String customerID;
  dynamic changePageHandler;

  OrderList({this.changePageHandler, this.keyword, this.customerID});

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<Order> orders = [];
  int currentPage = 1;
  bool isLoading = false;
  TextEditingController keyword = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

  Future<List<Order>> getProductsLocal() async {
    List<Order> temp = await OrderServices.getOrders(
        currentPage.toString(), widget.keyword, widget.customerID, false);
    setState(() {
      orders = orders.isEmpty ? temp : orders;
      currentPage = currentPage + 1;
      isLoading = false;
    });

    return temp;
  }

  @override
  void initState() {
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    super.initState();
    setState(() {
      keyword.text = widget.keyword;
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.keyword == null && widget.customerID == null
          ? null
          : AppBar(
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
              widget.keyword == null && widget.customerID == null ? 0 : 3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FaIcon(FontAwesomeIcons.cartArrowDown),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "orders".tr(),
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              widget.keyword != null || widget.customerID != null
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomeTextField(
                                controller: keyword,
                                validator: Validator.notEmpty,
                                hintTxt: "enter_order_id".tr(),
                                labelTxt: "order_id".tr(),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            CustomeButton(
                              title: "search".tr(),
                              icon: null,
                              handler: () {
                                if (_formKey.currentState.validate()) {
                                  Navigator.pushNamed(context, '/orders',
                                      arguments: {
                                        "keyword": keyword.text,
                                        "customerId": null
                                      });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
              orders.isEmpty && !isLoading ? ProductPlaceholder() : SizedBox(),
              orders.isEmpty && !isLoading
                  ? SizedBox()
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Pagination(
                          progress: loadingKit,
                          pageBuilder: (currentListSize) => getProductsLocal(),
                          itemBuilder: (index, Order order) => ListItem(
                            id: order.id.toString(),
                            time: timeago.format(
                            (DateTime.parse(order.createdAt)),
                            locale: 'ar'),
                            total: order.total.toString(),
                            currency: order.currency.toString(),
                            status: order.status.toString(),
                            items: order.items,
                            channel: order.channel,
                            address: order.address.address,
                            customerName: order.customer.name,
                            customerNumber: order.customer.phoneNumber,
                          ),
                        ),
                      ),
                    ),
            ],
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

  CustomeTextField(
      {this.hintTxt,
      this.labelTxt,
      this.controller,
      this.validator,
      this.obscureTextbool = false});

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
  String address;
  String time;
  String status;
  String total;
  String channel;
  String customerName;
  String customerNumber;

  String currency;
  List<Items> items;

  ListItem(
      {this.address,
      this.id,
      this.time,
      this.total,
      this.status,
      this.currency,
      this.items,
      this.customerNumber,
      this.customerName,this.channel});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#$id',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 23,
                        color: const Color(0xff8F8D8D),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      '$time',
                      style: TextStyle(
                        fontSize: 15,
                        color: const Color(0xff8F8D8D),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

                Text(
                  channel,
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xffff7600),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),

                Text(
                  status.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xffff7600),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '$address',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '$customerName',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '$customerNumber',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '$total $currency',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff000000),
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 26,
                  child: Row(
                    children: [
                      Expanded(
                          child: CustomeButton(
                        title: "order_items".tr(),
                        icon: null,
                        handler: () => Navigator.pushNamed(
                            context, '/orders_items',
                            arguments: items),
                      )),
                      Expanded(
                          child: CustomeButton(
                        title: "change_order_status".tr(),
                        icon: null,
                        handler: () => Navigator.pushNamed(
                            context, '/change_status', arguments: {
                          "orderId": id.toString(),
                          "currentStatus": status.toString()
                        }),
                      )),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        Divider()
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
            FontAwesomeIcons.cartArrowDown,
            size: 75,
            color: const Color(0xffe6d7d7),
          ),
          SizedBox(
            height: 12,
          ),
          Center(
            child: Text(
              'no_orders_yet'.tr(),
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
