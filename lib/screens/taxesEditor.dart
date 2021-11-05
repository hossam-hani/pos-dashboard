
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:eckit/models/category.dart';
import 'package:eckit/models/cost.dart';
import 'package:eckit/models/product.dart';
import 'package:eckit/models/store.dart';
import 'package:eckit/services/categories_service.dart';
import 'package:eckit/services/costs_service.dart';
import 'package:eckit/services/inventory_services.dart';
import 'package:eckit/services/product_service.dart';
import 'package:eckit/services/stores_service.dart';
import 'package:eckit/services/taxes_service.dart';
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

// ignore: must_be_immutable
class TaxesEditor extends StatefulWidget {
  @override
  _TaxesEditorState createState() => _TaxesEditorState();
}


class _TaxesEditorState extends State<TaxesEditor> {
  
   final _formKey = GlobalKey<FormState>();

   TextEditingController tax1Title = new TextEditingController();
   TextEditingController tax1Amount = new TextEditingController();

   TextEditingController tax2Title = new TextEditingController();
   TextEditingController tax2Amount = new TextEditingController();

   TextEditingController tax3Title = new TextEditingController();
   TextEditingController tax3Amount = new TextEditingController();

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
 



  initValues() async {
  
  setState(() {
      isLoading = true;
  });

  Taxes taxes = await TaxesService.getTaxes();

  setState(() {
    isLoading = false;
    tax1Title.text = taxes.tax1Title;
    tax1Amount.text = taxes.tax1Amount.toString();

    tax2Title.text = taxes.tax2Title;
    tax2Amount.text = taxes.tax2Amount.toString();

    tax3Title.text = taxes.tax3Title;
    tax3Amount.text = taxes.tax3Amount.toString();
  });

  }

  @override
  void initState() {
    super.initState();
    initValues();
  }


  @override
  Widget build(BuildContext context) {

  save() async {

    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState.validate()) {
      await TaxesService.saveTaxes(
          tax1Title: tax1Title.text,
          tax1Amount: tax1Amount.text.toString(),
          tax2Title: tax2Title.text,
          tax2Amount: tax2Amount.text.toString(),
          tax3Title: tax3Title.text,
          tax3Amount: tax3Amount.text.toString(),
        );
    }

    setState(() {
      isLoading = false;
    });

  }

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
          icon: FaIcon(FontAwesomeIcons.arrowRight,color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
          title: Image.asset("assets/images/logo.png" , height: 40,)
        ),
        backgroundColor: Colors.white,
        body: isLoading ? loadingKit : SingleChildScrollView(
              child: Form(
              key: _formKey,
              child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:   Text("الضريبة",
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
                    controller:  tax1Title,
                    hintTxt: "عنوان الضريبة 1".tr(),
                    labelTxt: "الضريبة 1".tr(),
                  ),
              ),
 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomeTextField(
                    controller:  tax1Amount,
                    hintTxt: "قيمة الضريبة 1".tr(),
                    labelTxt: "قيمة الضريبة 1".tr(),
                  ),
              ),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomeTextField(
                    controller:  tax2Title,
                    hintTxt: "عنوان الضريبة 2".tr(),
                    labelTxt: "الضريبة 2".tr(),
                  ),
              ),
 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomeTextField(
                    controller:  tax2Amount,
                    hintTxt: "قيمة الضريبة 2".tr(),
                    labelTxt: "قيمة الضريبة 2".tr(),
                  ),
              ),

              Divider(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomeTextField(
                    controller:  tax3Title,
                    hintTxt: "عنوان الضريبة 3".tr(),
                    labelTxt: "الضريبة 3".tr(),
                  ),
              ),
 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomeTextField(
                    controller:  tax3Amount,
                    hintTxt: "قيمة الضريبة 3".tr(),
                    labelTxt: "قيمة الضريبة 3".tr(),
                  ),
              ),

              Divider(),


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

  CustomeTextField({this.hintTxt,this.labelTxt,this.controller,this.validator,this.obscureTextbool = false});

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
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
              )
                  ),
            );
  }
}