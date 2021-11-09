import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:eckit/components/customeButton.dart';
import 'package:eckit/models/product.dart';
import 'package:eckit/models/store.dart';
import 'package:eckit/models/supplier.dart';
import 'package:eckit/services/orders_service.dart';
import 'package:eckit/services/product_service.dart';
import 'package:eckit/services/stores_service.dart';
import 'package:eckit/services/suppliers_service.dart';

//TODO: fix add supplier invoice

// ignore: must_be_immutable
class SupplierInvoiceEditor extends StatefulWidget {
  SupplierInvoiceEditor();

  @override
  _SupplierInvoiceEditorState createState() => _SupplierInvoiceEditorState();
}

class _SupplierInvoiceEditorState extends State<SupplierInvoiceEditor> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController cost = new TextEditingController();
  TextEditingController quantity = new TextEditingController();
  String type;
  Store fromStore;
  Product currentProduct;
  List<Supplier> suppliers;
  Supplier currentSupplier;

  bool isLoading = false;

  List<Store> stores;

  List<dynamic> items = [];

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

    List itemsec = [];

    items.forEach((element) {
      itemsec.add({
        "id": element["product"].id.toString(),
        "quantity": element["quantity"],
        "notes": null,
        "inventory_id": element["inventory"].id.toString(),
        "cost": element["cost"].toString(),
      });
    });

    if (_formKey.currentState.validate()) {
      try {
        await OrderServices.createSupplierInvoice(
          items: jsonEncode(itemsec),
          supplierId: currentSupplier.id.toString(),
        );
        Navigator.pop(context);
      } catch (e) {
        /* do nothing */
      }
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
    List<Supplier> tempSuppliers = await SuppliersServices.getAllSuppliers();

    setState(() {
      stores = temp;
      suppliers = tempSuppliers;
      isLoading = false;
    });
  }

  @override
  void initState() {
    initValues();
    super.initState();
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
                          "إنشاء فاتورة مورد جديدة",
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      isLoading
                          ? Text("loading")
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<Supplier>(
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
                            ),
                      Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "الفاتورة",
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
                      Row(
                        children: [
                          Expanded(
                            child: CustomeTextField(
                              controller: quantity,
                              hintTxt: "ادخل الكمية".tr(),
                              labelTxt: "الكمية".tr(),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomeTextField(
                              controller: cost,
                              hintTxt: "ادخل التكلفة".tr(),
                              labelTxt: "التكلفة".tr(),
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        leading: Text("الي مخزن"),
                        title: DropdownButton<Store>(
                          value: fromStore,
                          isExpanded: true,
                          hint: Text("اختر المخزن الذي الإضافة إليه"),
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
                      CustomeButton(
                        title: "إضافة الي الفاتورة",
                        icon: FontAwesomeIcons.plus,
                        handler: () {
                          setState(() {
                            items.add({
                              "product": currentProduct,
                              "cost": cost.text,
                              "quantity": quantity.text,
                              "inventory": fromStore
                            });
                            cost.clear();
                            quantity.clear();
                            fromStore = null;
                          });

                          print(items);
                        },
                      ),
                      ...items
                          .map((item) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${item["product"].name.toString()}  * ${item["quantity"]}  |  ${item["inventory"].name} ",
                                            style: TextStyle(fontSize: 18, fontFamily: "Lato"),
                                          ),
                                        ),
                                        Text(
                                          "${item["cost"]}",
                                          style: TextStyle(fontSize: 18, fontFamily: "Lato"),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                items.remove(item);
                                              });
                                            },
                                            child: FaIcon(
                                              FontAwesomeIcons.trash,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
                                    Divider(color: Colors.black)
                                  ],
                                ),
                              ))
                          .toList(),
                      SizedBox(
                        height: 10,
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
