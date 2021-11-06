import 'package:dropdown_search/dropdown_search.dart';
import 'package:eckit/models/customer.dart';
import 'package:eckit/models/supplier.dart';
import 'package:eckit/models/transaction.dart';
import 'package:eckit/services/customer_service.dart';
import 'package:eckit/services/suppliers_service.dart';
import 'package:eckit/services/transactions_service.dart';
import 'package:eckit/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

@immutable
class TranscationEditorArgumants {
  final Transaction transaction;
  final VoidCallback onSaveFinish;
  const TranscationEditorArgumants({
    this.transaction,
    this.onSaveFinish,
  });
}

class TranscationEditor extends StatefulWidget {
  final TranscationEditorArgumants transactionArgs;

  TranscationEditor({this.transactionArgs});

  @override
  _TranscationEditorState createState() => _TranscationEditorState();
}

class _TranscationEditorState extends State<TranscationEditor> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController amount = new TextEditingController();
  TextEditingController reason = new TextEditingController();

  bool isLoading = false;
  bool _isCredit = true;
  bool _isCustomer = true;

  List<Supplier> suppliers;
  Customer currentCustomer;
  Supplier currentSupplier;

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
      if (currentSupplier == null && currentCustomer == null) {
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
        //TODO: can't test adding new one without the clients
        try {
          await TransactionsServices.saveTransaction(
            amount: amount.text,
            reason: reason.text,
            recipientId: _isCustomer ? currentCustomer.id.toString() : currentSupplier.id.toString(),
            recipientType: _isCustomer ? "customer" : "supplier",
            type: _isCredit ? "credit" : "debit",
            id: widget.transactionArgs?.transaction?.id?.toString(),
          );
          Navigator.pop(context);
          widget.transactionArgs?.onSaveFinish?.call();
        } catch (e) {
          /*  do nothing */
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

    setState(() {
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
                    widget.transactionArgs != null ? "edit_transaction".tr() : "add_transaction".tr(),
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                CustomeTextField(
                  controller: amount,
                  validator: Validator.notEmpty,
                  hintTxt: "amount_hint_transcation".tr(),
                  labelTxt: "amount_label_transcation".tr(),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomeTextField(
                  controller: reason,
                  validator: Validator.notEmpty,
                  hintTxt: "reason_hint_transcation".tr(),
                  labelTxt: "reason_label_transcation".tr(),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    CupertinoSwitch(
                      value: _isCredit,
                      onChanged: (value) {
                        setState(() {
                          _isCredit = value;
                        });
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(_isCredit ? "credit".tr() : "debit".tr())
                  ],
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
