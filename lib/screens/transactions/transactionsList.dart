import 'package:dropdown_search/dropdown_search.dart';
import 'package:eckit/components/date_range_picker.dart';
import 'package:eckit/models/category.dart';
import 'package:eckit/models/customer.dart';
import 'package:eckit/models/stock.dart';
import 'package:eckit/models/supplier.dart';
import 'package:eckit/models/transaction.dart';
import 'package:eckit/services/customer_service.dart';
import 'package:eckit/services/stocks_service.dart';
import 'package:eckit/services/suppliers_service.dart';
import 'package:eckit/services/transactions_service.dart';
import 'package:eckit/utilties/time_formater.dart';
import 'package:flutter/cupertino.dart';

import '../../services/regions_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../components/customeButton.dart';
import 'package:paging/paging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../const.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../models/region.dart';
import 'TransactionEditor.dart';

class TransactionsList extends StatefulWidget {
  dynamic changePageHandler;
  dynamic changeCurrentIndex;
  String startAt;
  String endAt;
  String recipientType;
  String recipientId;

  TransactionsList(
      {this.changePageHandler,
      this.changeCurrentIndex,
      this.recipientType,
      this.recipientId,
      this.endAt,
      this.startAt});

  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  DateTime startFrom = DateTime.now();
  DateTime endAt = DateTime.now();

  bool _isCustomer = true;
  bool _openFilter = true;

  List<Supplier> suppliers;
  Customer currentCustomer;
  Supplier currentSupplier;

  List<Transaction> transactions = [];
  int currentPage = 1;
  bool isLoading = false;

  final loadingKit = Center(
    child: Column(
      children: [
        SizedBox(height: 20),
        SpinKitSquareCircle(size: 50.0, color: mainColor),
        SizedBox(height: 10),
        Text("loading".tr())
      ],
    ),
  );

  toggleFilter() {
    setState(() {
      _openFilter = !_openFilter;
    });
  }

  search() {
    Navigator.pushNamed(context, '/transactions', arguments: {
      "startAt": startFrom,
      "endAt": endAt,
      "recipientId": _isCustomer ? currentCustomer.id : currentSupplier.id,
      "recipientType": _isCustomer ? "customer" : "supplier",
    });
  }

  Future<List<Transaction>> getStocksLocal() async {
    List<Transaction> temp = await TransactionsServices.getTransactions(
      currentPage.toString(),
    );

    setState(() {
      transactions = transactions.isEmpty ? temp : transactions;
      currentPage = currentPage + 1;
      isLoading = false;
    });

    return temp;
  }

  getListOfSuppliers() async {
    List<Supplier> tempSuppliers = await SuppliersServices.getAllSuppliers();

    setState(() {
      suppliers = tempSuppliers;
    });
  }

  @override
  void initState() {
    super.initState();
    getListOfSuppliers();
    print(widget.recipientId);
    setState(() {
      isLoading = true;
    });
  }

  Future<void> _reloadData() async {
    setState(() {
      transactions.clear();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: FaIcon(FontAwesomeIcons.times, color: Colors.black),
            ),
          ),
          title: Image.asset(
            "assets/images/logo.png",
            height: 40,
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(FontAwesomeIcons.boxes),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "transactions".tr(),
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),

            Row(
              children: [
                CustomeButton(
                  title: "add_transaction",
                  icon: FontAwesomeIcons.plus,
                  handler: () => Navigator.pushNamed(context, '/transactions_editor',
                      arguments: TranscationEditorArgumants(
                        onSaveFinish: _reloadData,
                      )),
                ),
                !_openFilter
                    ? CustomeButton(
                        title: "filter",
                        icon: FontAwesomeIcons.search,
                        handler: toggleFilter,
                      )
                    : CustomeButton(
                        title: "close",
                        icon: FontAwesomeIcons.times,
                        handler: toggleFilter,
                      ),
              ],
            ),

            _openFilter
                ? Column(
                    children: [
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
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          CupertinoSwitch(
                            value: _isCustomer,
                            onChanged: (value) {
                              setState(() {
                                _isCustomer = value;
                              });
                            },
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(_isCustomer ? "customer".tr() : "supplier".tr())
                        ],
                      ),
                      _isCustomer
                          ? SizedBox()
                          : SizedBox(
                              height: 10,
                            ),
                      _isCustomer
                          ? SizedBox()
                          : isLoading
                              ? Text("loading")
                              : DropdownButton<Supplier>(
                                  value: currentSupplier,
                                  isExpanded: true,
                                  items: suppliers.map((Supplier supplier) {
                                    return new DropdownMenuItem<Supplier>(
                                      value: supplier,
                                      child: new Text(supplier.name),
                                    );
                                  }).toList(),
                                  hint: Text("select_supplier_hint".tr()),
                                  onChanged: (newValue) {
                                    setState(() {
                                      currentSupplier = newValue;
                                    });
                                  },
                                ),
                      !_isCustomer
                          ? SizedBox()
                          : SizedBox(
                              height: 10,
                            ),
                      !_isCustomer
                          ? SizedBox()
                          : DropdownSearch<Customer>(
                              mode: Mode.MENU,
                              showSearchBox: true,
                              itemAsString: (Customer u) => u.name.toString(),
                              label: "customer".tr(),
                              hint: "select_customer_hint".tr(),
                              isFilteredOnline: true,
                              onFind: (String filter) => CustomerServices.getCustomers("1", filter),
                              onChanged: (Customer data) {
                                setState(() {
                                  currentCustomer = data;
                                });
                              },
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomeButton(
                        title: "confirm".tr(),
                        handler: search,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                    ],
                  )
                : SizedBox(),

            // CustomeButton(title: "confirm".tr(),handler: search,),

            transactions.isEmpty && !isLoading ? CategoryPlaceholder() : SizedBox(),
            transactions.isEmpty && !isLoading
                ? SizedBox()
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Pagination(
                        progress: loadingKit,
                        pageBuilder: (currentListSize) => getStocksLocal(),
                        itemBuilder: (index, Transaction transaction) => ListItem(
                            amount: transaction.amount.toString(),
                            id: transaction.id.toString(),
                            transaction: transaction,
                            supplier: transaction.supplier,
                            customer: transaction.customer,
                            type: transaction.type),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  String amount;
  String id;
  String image;
  Supplier supplier;
  Customer customer;
  String type;

  Transaction transaction;

  ListItem({this.amount, this.id, this.image, this.transaction, this.supplier, this.customer, this.type});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 25,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#$id',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xffe6d7d7),
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  ' ${"amount".tr()} : $amount',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '$type',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                customer == null
                    ? SizedBox()
                    : Text(
                        '${"customer".tr()} : ${customer.name}',
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xff3a3a3a),
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.start,
                      ),
                customer == null
                    ? SizedBox()
                    : SizedBox(
                        height: 10,
                      ),
                supplier == null
                    ? SizedBox()
                    : Text(
                        '${"supplier".tr()} : ${supplier.name}',
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xff3a3a3a),
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.left,
                      ),
                supplier == null
                    ? SizedBox()
                    : Text(
                        '${supplier.notes}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.start,
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

class CategoryPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.mapMarked,
            size: 75,
            color: const Color(0xffe6d7d7),
          ),
          SizedBox(
            height: 12,
          ),
          Center(
            child: Text(
              'start_add_your_stocks'.tr(),
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
          SizedBox(
              width: 200,
              child: CustomeButton(
                title: "add_region",
                icon: FontAwesomeIcons.plus,
                handler: () => Navigator.pushNamed(context, '/region_editor'),
              )),
        ],
      ),
    );
  }
}
