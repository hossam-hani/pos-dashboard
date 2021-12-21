import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:eckit/models/product.dart';
import 'package:eckit/models/store.dart';
import 'package:eckit/services/inventory_services.dart';
import 'package:eckit/services/product_service.dart';
import 'package:eckit/services/stores_service.dart';

// ignore: must_be_immutable
class InventoryTransactionEditor extends StatefulWidget {
  Store store;

  InventoryTransactionEditor({this.store});

  @override
  _InventoryTransactionEditorState createState() => _InventoryTransactionEditorState();
}

class _InventoryTransactionEditorState extends State<InventoryTransactionEditor> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = new TextEditingController();
  TextEditingController quantity = new TextEditingController();
  String type;
  Store fromStore;
  Store toStore;
  Product currentProduct;

  bool isLoading = false;

  List<Store> stores;

  var loadingKit = Center(
    child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        SpinKitSquareCircle(
          color: Colors.white,
          size: 50.0,
        ),
      ],
    ),
  );

  save() async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState.validate()) {
      await InventoryServices.createTranscations(
          quantity: quantity.text,
          type: type,
          from: fromStore.id,
          to: toStore == null ? null : toStore.id,
          productId: currentProduct.id.toString(),
          context: context);
    }

    setState(() {
      isLoading = false;
    });
  }

  initValues() async {
    setState(() {
      isLoading = true;
    });

    List<Store> temp = await StoreServices.getAllStores();

    setState(() {
      stores = temp;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: save,
        child: Container(
          child: Center(
            child: isLoading
                ? loadingKit
                : Text(
                    "save".tr(),
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
          ),
          height: 80.0,
          decoration: BoxDecoration(
            color: const Color(0xff1e272e),
          ),
        ),
      ),
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
      body: isLoading
          ? loadingKit
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "إنشاء حركة مخزون",
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomeTextField(
                          controller: quantity,
                          hintTxt: "ادخل الكمية".tr(),
                          labelTxt: "الكمية".tr(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        leading: Text("نوع حركة المخزون"),
                        title: DropdownButton<String>(
                          value: type,
                          isExpanded: true,
                          hint: Text("اختر نوع حركة المخزن"),
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              type = newValue;
                            });
                          },
                          items: <String>['transfer', 'sales', 'purchases', 'losses']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value == "sales"
                                  ? "مبيعات"
                                  : value == "purchases"
                                      ? "مشتريات"
                                      : value == "transfer"
                                          ? "نقل"
                                          : "هوالك"),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Text("من مخزن"),
                        title: DropdownButton<Store>(
                          value: fromStore,
                          isExpanded: true,
                          hint: Text("اختر المخزن الذي سيتم الاختصام منه او الإضافة إليه"),
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (Store newValue) {
                            setState(() {
                              fromStore = newValue;
                            });
                          },
                          items: stores.map<DropdownMenuItem<Store>>((Store store) {
                            return DropdownMenuItem<Store>(
                              value: store,
                              child: Text(store.name.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      type == "transfer"
                          ? ListTile(
                              leading: Text("الي مخزن"),
                              title: DropdownButton<Store>(
                                value: toStore,
                                isExpanded: true,
                                hint: Text("اختر المخزن الذي سيتم الاختصام منه او الإضافة إليه"),
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (Store newValue) {
                                  setState(() {
                                    toStore = newValue;
                                  });
                                },
                                items: stores.map<DropdownMenuItem<Store>>((Store store) {
                                  return DropdownMenuItem<Store>(
                                    value: store,
                                    child: Text(store.name.toString()),
                                  );
                                }).toList(),
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownSearch<Product>(
                          mode: Mode.MENU,
                          showSearchBox: true,
                          itemAsString: (Product u) => u.name.toString(),
                          label: "product".tr(),
                          hint: "select_product_hint".tr(),
                          isFilteredOnline: true,
                          onFind: (String filter) => ProductServices.productsSearch(filter),
                          onChanged: (Product data) {
                            setState(() {
                              currentProduct = data;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
