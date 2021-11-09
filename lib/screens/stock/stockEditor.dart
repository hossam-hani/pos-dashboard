import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eckit/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:eckit/models/product.dart';
import 'package:eckit/models/stock.dart';
import 'package:eckit/models/store.dart';
import 'package:eckit/models/supplier.dart';
import 'package:eckit/services/product_service.dart';
import 'package:eckit/services/stocks_service.dart';
import 'package:eckit/services/stores_service.dart';
import 'package:eckit/services/suppliers_service.dart';

@immutable
class StockEditorArgumants {
  final Stock stock;
  final VoidCallback onSaveFinish;
  const StockEditorArgumants({
    this.stock,
    this.onSaveFinish,
  });
}

class StockEditor extends StatefulWidget {
  final StockEditorArgumants stockArgs;

  StockEditor({this.stockArgs});

  @override
  _StockEditorState createState() => _StockEditorState();
}

class _StockEditorState extends State<StockEditor> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController quantity = new TextEditingController();
  bool _isActive = true;
  bool _isMainRegion = true;
  bool isLoading = false;
  List<Store> stores;
  List<Supplier> suppliers;
  Store currentStore;
  Supplier currentSupplier;

  Product currentProduct;

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
      if (currentProduct == null || currentSupplier == null || currentStore == null) {
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('alert'.tr()),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('all_feilds_are_required'.tr()),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('okay'.tr()),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      } else {
        try {
          await StocksServices.saveStock(
              quantity: quantity.text,
              productId: currentProduct.id.toString(),
              storeId: currentStore.id.toString(),
              supplierId: currentSupplier.id.toString(),
              id: widget.stockArgs?.stock?.id?.toString());

          Navigator.pop(context);
          widget.stockArgs?.onSaveFinish?.call();
        } catch (e) {
          /* do nothing */
        }
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

    List<Supplier> tempSuppliers = await SuppliersServices.getAllSuppliers();
    List<Store> tempStores = await StoreServices.getAllStores();

    setState(() {
      stores = tempStores;
      suppliers = tempSuppliers;
    });

    // if(widget.region != null){

    // temp.forEach((reg) {
    //   if(reg.id.toString() == widget.region.regionId){
    //     setState(() {
    //       currentRegion = reg;
    //     });
    //   }
    // });

    //   setState(() {
    //     name.text = widget.region.name;
    //     _isMainRegion = widget.region.regionId == null ? true : false;
    //     fees.text = widget.region.fees == null ? null : widget.region.fees.toString();
    //     _isActive = widget.region.isActive;
    //   });
    // }

    setState(() {
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
      body: SingleChildScrollView(
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
                    widget.stockArgs != null ? "edit_stock".tr() : "add_stock".tr(),
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                CustomeTextField(
                  controller: quantity,
                  validator: Validator.notEmpty,
                  hintTxt: "quantity_hint_stock".tr(),
                  labelTxt: "quantity_label_stock".tr(),
                ),
                SizedBox(
                  height: 20,
                ),
                isLoading
                    ? Text("loading")
                    : DropdownButton<Store>(
                        value: currentStore,
                        isExpanded: true,
                        items: stores.map((Store store) {
                          return new DropdownMenuItem<Store>(
                            value: store,
                            child: new Text(store.name),
                          );
                        }).toList(),
                        hint: Text("select_store_hint".tr()),
                        onChanged: (newValue) {
                          setState(() {
                            currentStore = newValue;
                          });
                        },
                      ),
                isLoading
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
                SizedBox(
                  height: 20,
                ),
                DropdownSearch<Product>(
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
