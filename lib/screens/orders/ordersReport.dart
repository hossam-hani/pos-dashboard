import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:eckit/components/date_range_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:paging/paging.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:eckit/models/account.dart';
import 'package:eckit/models/items.dart';
import 'package:eckit/models/order.dart';
import 'package:eckit/services/account_service.dart';
import 'package:eckit/services/orders_service.dart';
import 'package:eckit/utilties/time_formater.dart';

import '../../components/customeButton.dart';
import '../../const.dart';

class OrdersReport extends StatefulWidget {
  final String customerId;
  final String startAt;
  final String endAt;
  final String userId;

  const OrdersReport({
    this.customerId,
    this.startAt,
    this.endAt,
    this.userId,
  });

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<OrdersReport> {
  Key _paginatorKey = UniqueKey();
  final keyword = TextEditingController();
  List<Order> orders = [];
  int currentPage = 1;
  bool isLoading = true;
  String totalBalance = '0';

  DateTime startFrom;
  DateTime endAt;
  User user;

  List<User> users;

  @override
  void initState() {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    getOrdersLocal();
    getTotalForOrders();
    super.initState();
  }

  Future<void> _performFiltering() async {
    currentPage = 1;
    _paginatorKey = UniqueKey();
    if (mounted) setState(() {});
    await getTotalForOrders();
  }

  Future<List<Order>> getOrdersLocal() async {
    final _startAt = startFrom == null ? widget.startAt : DateFormat('yyyy-MM-dd').format(startFrom);
    final _endAt = endAt == null ? widget.endAt : DateFormat('yyyy-MM-dd').format(endAt);
    List<Order> temp = await OrderServices.getOrdersReport(
      currentPage.toString(),
      customerId: widget.customerId,
      startAt: _startAt,
      endAt: _endAt,
      userId: user?.id?.toString() ?? widget.userId,
    );

    setState(() {
      orders = orders.isEmpty ? temp : orders;
      currentPage = currentPage + 1;
      isLoading = false;
    });

    return temp;
  }

  Future<void> getTotalForOrders() async {
    final _startAt = startFrom == null ? widget.startAt : DateFormat('yyyy-MM-dd').format(startFrom);
    final _endAt = endAt == null ? widget.endAt : DateFormat('yyyy-MM-dd').format(endAt);
    final valTemp = await OrderServices.gerOrdersTotalPrice(
      currentPage.toString(),
      customerId: widget.customerId,
      startAt: _startAt,
      endAt: _endAt,
      userId: user?.id?.toString() ?? widget.userId,
    );

    List<User> temp = await AccountService.getUsers(currentPage.toString());

    setState(() {
      users = temp;
      totalBalance = valTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     currentPage = 1;
      //     _paginatorKey = UniqueKey();
      //     setState(() {});
      //   },
      // ),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.arrowRight, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          "assets/images/logo.png",
          height: 40,
        ),
      ),
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
                    FaIcon(FontAwesomeIcons.receipt),
                    SizedBox(width: 10),
                    Text(
                      "????????????????".tr(),
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
                SizedBox(height: 10),
                if (users != null)
                  ListTile(
                    leading: Text("??????????????"),
                    title: DropdownButton<User>(
                      value: user,
                      isExpanded: true,
                      hint: Text("???????? ?????????????? ???????? ???????? ???? ?????????? ??????????????"),
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (User newValue) {
                        setState(() {
                          user = newValue;
                        });
                      },
                      items: users.map<DropdownMenuItem<User>>((User uuser) {
                        return DropdownMenuItem<User>(
                          value: uuser,
                          child: Text(uuser.name.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                SizedBox(height: 10),
                CustomeButton(
                  handler: _performFiltering,
                  title: "confirm".tr(),
                ),
                ListTile(
                  title: Text("???????????? ???????????????? : ${totalBalance ?? "0"} EGP "),
                ),
                orders.isEmpty && !isLoading ? ProductPlaceholder() : SizedBox(),
                orders.isEmpty && !isLoading
                    ? SizedBox.shrink()
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Pagination(
                            key: _paginatorKey,
                            progress: loadingKit,
                            pageBuilder: (currentListSize) => getOrdersLocal(),
                            itemBuilder: (index, Order order) => ListItem(
                              id: order.id.toString(),
                              customerName: order.customer.name,
                              date: order.createdAt,
                              total: order.total.toString(),
                              items: order.items,
                              tax1: order.tax1.toString(),
                              tax1Amount: order.tax1Amount.toString(),
                              tax2: order.tax2.toString(),
                              tax2Amount: order.tax2Amount.toString(),
                              tax3: order.tax3.toString(),
                              tax3Amount: order.tax3Amount.toString(),
                              user: order.user,
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

  final loadingKit = Center(
    child: Column(
      children: [
        SizedBox(height: 20),
        SpinKitSquareCircle(color: mainColor, size: 50.0),
        SizedBox(height: 10),
        Text("loading".tr())
      ],
    ),
  );
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
  String customerName;
  String total;
  String date;
  List<Items> items;
  String tax1;
  String tax1Amount;
  String tax2;
  String tax2Amount;
  String tax3;
  String tax3Amount;
  User user;

  ListItem(
      {this.customerName,
      this.id,
      this.total,
      this.date,
      this.items,
      this.tax1,
      this.tax1Amount,
      this.tax2,
      this.tax2Amount,
      this.tax3,
      this.tax3Amount,
      this.user});
  @override
  Widget build(BuildContext context) {
    double cost = 0;

    items.forEach((e) {
      cost = cost + e.cost;
    });

    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
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
                    '?????? ???????????? : $customerName',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color(0xff3a3a3a),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  user != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '?????? ?????????????? : ${user.name}',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color(0xff3a3a3a),
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 8,
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
                  Text(
                    '?????????? ???????????????? : $cost ????????',
                    style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.w300, fontFamily: "Lato"),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    '?????????? ???????????????? : ${double.parse(total) - cost} ????????',
                    style:
                        TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.w300, fontFamily: "Lato"),
                    textAlign: TextAlign.left,
                  ),
                  tax1 == null || tax1 == "null"
                      ? SizedBox()
                      : Text(
                          '?????????? ($tax1) : $tax1Amount ????????',
                          style: TextStyle(
                              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w300, fontFamily: "Lato"),
                          textAlign: TextAlign.left,
                        ),
                  tax2 == null || tax2 == "null"
                      ? SizedBox()
                      : Text(
                          '?????????? ($tax2) : $tax2Amount ????????',
                          style: TextStyle(
                              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w300, fontFamily: "Lato"),
                          textAlign: TextAlign.left,
                        ),
                  tax3 == null || tax3 == "null"
                      ? SizedBox()
                      : Text(
                          '?????????? ($tax3) : $tax3Amount ????????',
                          style: TextStyle(
                              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w300, fontFamily: "Lato"),
                          textAlign: TextAlign.left,
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
      ),
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

///triggers a callback when reaching the scollable widget bottom.
///
extension BottomTrigger on ScrollController {
  ///Triggers [onTrigger] when scrolable widget reaches the [limitFraction] point
  ///
  ///which is the fraction of the screen at which the [onTrigger] is called.
  ///
  ///[limitFraction] default to `0.9`.
  ///
  void onScroll(VoidCallback onTrigger, {double limitFraction}) {
    addListener(() {
      if (!_isBottom(limitFraction ?? 0.9)) return;
      onTrigger.call();
    });
  }

  bool _isBottom(double limitFraction) {
    if (!hasClients) return false;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = offset;
    return currentScroll >= (maxScroll * limitFraction);
  }
}
