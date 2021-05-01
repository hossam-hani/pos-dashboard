
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:eckit/models/category.dart';
import 'package:eckit/models/store.dart';
import 'package:eckit/models/supplier.dart';
import 'package:eckit/services/categories_service.dart';
import 'package:eckit/services/stores_service.dart';
import 'package:eckit/services/suppliers_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';

import '../../const.dart';
import '../../validator.dart';
import '../../models/region.dart';
import '../../services/regions_service.dart';

class SuppliersEditor extends StatefulWidget {

  Supplier supplier;

  SuppliersEditor({this.supplier});

  @override
  _SupplierEditorState createState() => _SupplierEditorState();
}


class _SupplierEditorState extends State<SuppliersEditor> {
  
   final _formKey = GlobalKey<FormState>();
   TextEditingController name = new TextEditingController();
   TextEditingController notes = new TextEditingController();

   bool isLoading = false;



  var loadingKit = Center(
        child: Column(children: [
          SizedBox(height: 20,),
          SpinKitSquareCircle(
          color: Colors.white,
          size: 50.0,
        ),
        ],),
      );
 

  save() async {

    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState.validate()) {
      await SuppliersServices.savSupplier(name: name.text,notes: notes.text, id: widget.supplier == null ? null : widget.supplier.id.toString());
    }

    setState(() {
      isLoading = false;
    });

  }

  initValues() async {
  
  setState(() {
      isLoading = true;
  });


  if(widget.supplier != null){

    setState(() {
      name.text = widget.supplier.name;
      notes.text = widget.supplier.notes;
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
      bottomNavigationBar:  InkWell(
        onTap: save,
          child: Container(
          child: Center(
            child: isLoading ? loadingKit : Text(
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
            color: const Color(0xfff38a2e),
          ),
        ),
      ),
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: new IconButton(
          icon: FaIcon(FontAwesomeIcons.arrowRight,color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
          title: Image.asset("assets/images/logo.png" , height: 70,)
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
                  child:   Text(
                    widget.supplier != null ? "edit_supplier".tr() : "add_supplier".tr(),
                    style: TextStyle(  
                      fontSize: 20,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,  
                  ),
                ),


                CustomeTextField(
                  controller:  name,
                  validator: Validator.notEmpty,
                  hintTxt: "name_hint_supplier".tr(),
                  labelTxt: "name_label_supplier".tr(),
                ),


                CustomeTextField(
                  controller:  notes,
                  validator: Validator.notEmpty,
                  hintTxt: "name_notes_supplier".tr(),
                  labelTxt: "name_notes_supplier".tr(),
                  minLines: 5,
                  maxLines: 10,  
                ),


              SizedBox(height: 20,),

  
                
              ],),
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

  CustomeTextField({this.hintTxt,this.labelTxt,
  this.controller,this.validator,this.obscureTextbool = false,this.maxLines,this.minLines});

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
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
              )
                  ),
            );
  }
}