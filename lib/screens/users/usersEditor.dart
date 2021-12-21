import 'package:eckit/models/account.dart';
import 'package:eckit/models/store.dart';
import 'package:eckit/services/account_service.dart';
import 'package:eckit/services/stores_service.dart';
import 'package:eckit/services/taxes_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../const.dart';
import '../../validator.dart';

@immutable
class UsersEditorArgumants {
  final User user;
  final VoidCallback onSaveFinish;
  const UsersEditorArgumants({
    this.user,
    this.onSaveFinish,
  });
}

class UsersEditor extends StatefulWidget {
  final UsersEditorArgumants userArgs;

  UsersEditor({this.userArgs});

  @override
  _UsersEditorState createState() => _UsersEditorState();
}

class _UsersEditorState extends State<UsersEditor> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  String currentRole;
  bool _isBlocked = false;
  bool _tax1 = false;
  bool _tax2 = false;
  bool _tax3 = false;
  bool isLoading = false;
  Store fromStore;
  List<Store> stores;
  Taxes taxes;

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
      try {
        await AccountService.saveUser(
          name: name.text,
          email: email.text,
          password: password.text,
          phone: phone.text,
          role: currentRole,
          isBlocked: _isBlocked,
          id: widget.userArgs?.user?.id?.toString(),
          inventoryId: fromStore != null ? fromStore.id.toString() : null,
          tax1: _tax1,
          tax2: _tax2,
          tax3: _tax3,
        );
        Navigator.pop(context);
        widget.userArgs?.onSaveFinish?.call();
      } catch (e) {
        /* do nothong */
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
    Taxes taxesT = await TaxesService.getTaxes();

    final user = widget.userArgs?.user;

    if (user != null) {
      setState(() {
        name.text = user.name;
        email.text = user.email;
        phone.text = user.phone;
        currentRole = user.role;
        _isBlocked = user.isBlocked;
      });
    }

    setState(() {
      stores = temp;
      taxes = taxesT;
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
                    widget.userArgs != null ? "edit_user".tr() : "add_user".tr(),
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                CustomeTextField(
                  controller: name,
                  validator: Validator.notEmpty,
                  hintTxt: "name_hint_user".tr(),
                  labelTxt: "name_label_user".tr(),
                ),
                CustomeTextField(
                  controller: email,
                  validator: Validator.notEmpty,
                  hintTxt: "email_hint_user".tr(),
                  labelTxt: "email_label_user".tr(),
                ),
                widget.userArgs != null
                    ? SizedBox()
                    : CustomeTextField(
                        controller: password,
                        validator: Validator.notEmpty,
                        hintTxt: "password_hint_user".tr(),
                        labelTxt: "password_label_user".tr(),
                      ),
                CustomeTextField(
                  controller: phone,
                  validator: Validator.notEmpty,
                  hintTxt: "phone_hint_user".tr(),
                  labelTxt: "phone_label_user".tr(),
                ),
                SizedBox(
                  height: 10,
                ),
                new DropdownButton<String>(
                  isExpanded: true,
                  value: currentRole,
                  items: usersRolsList.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value.tr()),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      currentRole = newVal;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                widget.userArgs == null
                    ? SizedBox()
                    : Row(
                        children: [
                          CupertinoSwitch(
                            value: _isBlocked,
                            onChanged: (value) {
                              setState(() {
                                _isBlocked = value;
                              });
                            },
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(_isBlocked ? "blockead".tr() : "active".tr())
                        ],
                      ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "المخزن",
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                if (stores != null)
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
                Divider(),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "الضرائب",
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                if (taxes != null)
                  Row(
                    children: [
                      CupertinoSwitch(
                        value: _tax1,
                        onChanged: (value) {
                          setState(() {
                            _tax1 = value;
                          });
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(!_tax1
                          ? "ضريبة [ ${taxes.tax1Title} ${taxes.tax1Amount} ] غير مفعلة"
                          : "ضريبة [ ${taxes.tax1Title} ${taxes.tax1Amount} ] مفعلة")
                    ],
                  ),
                SizedBox(
                  height: 15,
                ),
                if (taxes != null)
                  Row(
                    children: [
                      CupertinoSwitch(
                        value: _tax2,
                        onChanged: (value) {
                          setState(() {
                            _tax2 = value;
                          });
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(!_tax2
                          ? "ضريبة [ ${taxes.tax2Title} ${taxes.tax2Amount} ] غير مفعلة"
                          : "ضريبة [ ${taxes.tax2Title} ${taxes.tax2Amount} ] مفعلة")
                    ],
                  ),
                SizedBox(
                  height: 15,
                ),
                if (taxes != null)
                  Row(
                    children: [
                      CupertinoSwitch(
                        value: _tax3,
                        onChanged: (value) {
                          setState(() {
                            _tax3 = value;
                          });
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(!_tax3
                          ? "ضريبة [ ${taxes.tax3Title} ${taxes.tax3Amount} ] غير مفعلة"
                          : "ضريبة [ ${taxes.tax3Title} ${taxes.tax3Amount} ] مفعلة")
                    ],
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
  int minLines;
  int maxLines;

  CustomeTextField(
      {this.hintTxt,
      this.labelTxt,
      this.controller,
      this.validator,
      this.obscureTextbool = false,
      this.maxLines,
      this.minLines});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureTextbool,
      validator: validator,
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
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
