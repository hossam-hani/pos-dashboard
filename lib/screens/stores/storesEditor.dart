import 'package:eckit/models/store.dart';
import 'package:eckit/services/stores_service.dart';
import 'package:eckit/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

@immutable
class StoreEditorArgumants {
  final Store store;
  final VoidCallback onSaveFinish;
  const StoreEditorArgumants({
    this.store,
    this.onSaveFinish,
  });
}

class StoreEditor extends StatefulWidget {
  final StoreEditorArgumants storeArgs;

  StoreEditor({this.storeArgs});

  @override
  _StoreEditorState createState() => _StoreEditorState();
}

class _StoreEditorState extends State<StoreEditor> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = new TextEditingController();
  bool isLoading = false;

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
    setState(() => isLoading = true);

    if (_formKey.currentState.validate()) {
      try {
        await StoreServices.saveStore(
          name: name.text,
          id: widget.storeArgs?.store?.id,
        );
        Navigator.pop(context);
        widget.storeArgs?.onSaveFinish?.call();
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
    final store = widget.storeArgs?.store;
    if (store != null) {
      setState(() {
        name.text = store.name;
      });
    }

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
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.arrowRight, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Image.asset(
          "assets/images/logo.png",
          height: 40,
        ),
      ),
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
                    widget.storeArgs != null ? "edit_store".tr() : "add_store".tr(),
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
                  hintTxt: "name_hint_store".tr(),
                  labelTxt: "name_label_store".tr(),
                ),
                SizedBox(height: 20),
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
