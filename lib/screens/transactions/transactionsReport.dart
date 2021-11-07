import 'package:eckit/models/address.dart';
import 'package:eckit/models/customer.dart';
import 'package:eckit/models/items.dart';
import 'package:eckit/models/order.dart';
import 'package:eckit/models/transaction.dart';
import 'package:eckit/services/customer_service.dart';
import 'package:eckit/services/orders_service.dart';
import 'package:eckit/services/transactions_service.dart';
import 'package:eckit/utilties/time_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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

class TransactionsReport extends StatefulWidget {
  String customerId;
  String startAt;
  String endAt;

  TransactionsReport({this.customerId, this.startAt, this.endAt});

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<TransactionsReport> {
  final keyword = TextEditingController();
  List<Transaction> transctions = [];
  int currentPage = 1;
  bool isLoading = false;
  String totalBalance = '0';

  DateTime startFrom;
  DateTime endAt;

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

  Future<List<Transaction>> getTransctionsLocal() async {
    final _startAt = startFrom == null ? null : DateFormat('yyyy-MM-dd').format(startFrom);
    final _endAt = endAt == null ? null : DateFormat('yyyy-MM-dd').format(endAt);

    List<Transaction> temp = await TransactionsServices.getTransactionsForCustomers(
      currentPage.toString(),
      customerId: widget.customerId,
      startAt: _startAt ?? widget.startAt,
      endAt: _endAt ?? widget.endAt,
    );

    setState(() {
      transctions = transctions.isEmpty ? temp : transctions;
      currentPage = currentPage + 1;
      isLoading = false;
    });

    return temp;
  }

  getBalanceOfCustomer() async {
    final _startAt = startFrom == null ? null : DateFormat('yyyy-MM-dd').format(startFrom);
    final _endAt = endAt == null ? null : DateFormat('yyyy-MM-dd').format(endAt);

    String valTemp = await TransactionsServices.getTransactionsCustomersForTotal(
      currentPage.toString(),
      customerId: widget.customerId,
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
    getBalanceOfCustomer();

    setState(() => isLoading = true);
    super.initState();
  }

  Future<void> _reloadData() async {
    setState(() {
      transctions.clear();
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
                    FaIcon(FontAwesomeIcons.balanceScale),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "السندات".tr(),
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2020, 1, 1),
                                maxTime: DateTime(2050, 1, 1), onChanged: (date) {
                              setState(() {
                                startFrom = date;
                              });
                            }, onConfirm: (date) {
                              setState(() {
                                startFrom = date;
                              });
                            }, currentTime: startFrom, locale: LocaleType.ar);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'startFrom'.tr(),
                                style: TextStyle(color: Colors.blue),
                              ),
                              Text(
                                formateDateWithoutTime(startFrom ?? DateTime.now()),
                                style: TextStyle(color: Colors.grey, fontFamily: "Lato", fontSize: 12),
                              )
                            ],
                          )),
                    ),
                    Expanded(
                      child: FlatButton(
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2020, 1, 1),
                                maxTime: DateTime(2050, 1, 1), onChanged: (date) {
                              setState(() {
                                endAt = date;
                              });
                            }, onConfirm: (date) {
                              setState(() {
                                endAt = date;
                              });
                            }, currentTime: endAt, locale: LocaleType.ar);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'endAt'.tr(),
                                style: TextStyle(color: Colors.blue),
                              ),
                              Text(
                                formateDateWithoutTime(endAt ?? DateTime.now()),
                                style: TextStyle(color: Colors.grey, fontFamily: "Lato", fontSize: 12),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                CustomeButton(
                  handler: _reloadData,
                  title: "confirm".tr(),
                ),
                ListTile(
                  title: Text("اجمالي السندات : ${totalBalance ?? "0"} EGP "),
                ),
                transctions.isEmpty && !isLoading ? ProductPlaceholder() : SizedBox(),
                transctions.isEmpty && !isLoading
                    ? SizedBox()
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Pagination(
                            progress: loadingKit,
                            pageBuilder: (currentListSize) => getTransctionsLocal(),
                            itemBuilder: (index, Transaction transaction) => ListItem(
                              id: transaction.id.toString(),
                              customerName: transaction.customer.name,
                              date: transaction.createdAt,
                              reason: transaction.reason,
                              amount: transaction.amount.toString(),
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
  String customerName;
  String reason;
  String date;
  String amount;

  ListItem({this.customerName, this.id, this.reason, this.date, this.amount});
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
                  'رقم السند : #$id',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 18,
                    color: const Color(0xff8F8D8D),
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  'اسم العميل : $customerName',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  'المبلغ : $amount جنيه',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  'البيان : $reason',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                const Divider(),
                Text(
                  'التوقيت : ${formateStringTime(date)}',
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
