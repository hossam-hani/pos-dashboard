import 'dart:developer';

import 'package:eckit/components/date_range_picker.dart';
import 'package:eckit/models/address.dart';
import 'package:eckit/models/cost.dart';
import 'package:eckit/models/customer.dart';
import 'package:eckit/models/items.dart';
import 'package:eckit/models/order.dart';
import 'package:eckit/models/transaction.dart';
import 'package:eckit/services/costs_service.dart';
import 'package:eckit/services/customer_service.dart';
import 'package:eckit/services/orders_service.dart';
import 'package:eckit/services/transactions_service.dart';
import 'package:eckit/utilties/time_formater.dart';
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
import 'package:intl/intl.dart';

class CostsReport extends StatefulWidget {
  String type;
  String startAt;
  String endAt;

  CostsReport({this.type, this.startAt, this.endAt});

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CostsReport> {
  List<Cost> orders = [];
  int currentPage = 1;
  bool isLoading = false;
  TextEditingController keyword = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String totalBalance = '0';

  DateTime startFrom;
  DateTime endAt;
  String type;

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

  // search() {
  //   Navigator.pop(context);

  //   Navigator.pushNamed(context, '/costs_reports', arguments: {
  //     "startAt": DateFormat('yyyy-MM-dd').format(startFrom),
  //     "endAt": DateFormat('yyyy-MM-dd').format(endAt),
  //     "type": type,
  //   });
  // }

  Future<List<Cost>> getOrdersLocal() async {
    final _startAt = startFrom == null ? null : DateFormat('yyyy-MM-dd').format(startFrom);
    final _endAt = endAt == null ? null : DateFormat('yyyy-MM-dd').format(endAt);
    List<Cost> temp = await CostServices.getCostsReport(
      currentPage.toString(),
      type: widget.type,
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

  getTotalForOrders() async {
    final _startAt = startFrom == null ? null : DateFormat('yyyy-MM-dd').format(startFrom);
    final _endAt = endAt == null ? null : DateFormat('yyyy-MM-dd').format(endAt);
    String valTemp = await CostServices.gerCostsTotal(
      currentPage.toString(),
      type: widget.type,
      startAt: _startAt ?? widget.startAt,
      endAt: _endAt ?? widget.endAt,
    );

    setState(() {
      totalBalance = valTemp;
    });
  }

  @override
  void initState() {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    getTotalForOrders();

    super.initState();
    setState(() {
      type = widget.type;
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
                    FaIcon(FontAwesomeIcons.receipt),
                    SizedBox(
                      width: 10,
                    ),
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
                    if (mounted) {
                      setState(() {
                        startFrom = from;
                        endAt = to;
                      });
                    }
                  },
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  value: type,
                  hint: Text("???????? ?????? ??????????????"),
                  items: <String>['expenses', 'losses', 'salaries'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      onTap: () {
                        setState(() {
                          type = value;
                        });
                      },
                      child:
                          new Text("${value == "expenses" ? "????????????????" : value == "losses" ? "??????????????" : "????????????????"}"),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
                SizedBox(
                  height: 10,
                ),
                CustomeButton(
                  handler: _reloadData,
                  title: "confirm".tr(),
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustomeButton(
                      title: "?????????? ??????????",
                      icon: FontAwesomeIcons.plus,
                      handler: () => Navigator.pushNamed(context, '/cost_editor'),
                    )),
                  ],
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
                            itemBuilder: (index, Cost cost) => ListItem(
                              id: cost.id.toString(),
                              costType: cost.type,
                              date: cost.createdAt,
                              note: cost.notes,
                              amount: cost.amount.toString(),
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
  String costType;
  String amount;
  String note;
  String date;

  ListItem({this.costType, this.id, this.amount, this.date, this.note});
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
                Text(
                  '?????? ?????????????? : #$id',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 18,
                    color: const Color(0xff8F8D8D),
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '???????????? : $note',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '?????? ?????????????? : ${costType == "expenses" ? "????????????????" : costType == "losses" ? "??????????????" : "????????????????"}',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '???????? ?????????????? : $amount ????????',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                Divider(),
                Text(
                  '?????????????? : $date',
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
