
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
class CostEditor extends StatefulWidget {

  Cost cost;

  CostEditor({this.cost});

  @override
  _CostEditorState createState() => _CostEditorState();
}


class _CostEditorState extends State<CostEditor> {
  
   final _formKey = GlobalKey<FormState>();
   TextEditingController notes = new TextEditingController();
   TextEditingController amount = new TextEditingController();
   String type;


   Product currentProduct;

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

  List<Store> temp = await StoreServices.getAllStores();

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

  save() async {

    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState.validate()) {
      await CostServices.createCost(
        amount: amount.text,
        notes: notes.text,
        type: type,
        context: context
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
                  child:   Text("إضافة مصروف",
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
                    controller:  amount,
                    hintTxt: "قيمة المصروف".tr(),
                    labelTxt: "القيمة".tr(),
                  ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomeTextField(
                    controller:  notes,
                    hintTxt: "ادخل البيان".tr(),
                    labelTxt: "البيان".tr(),
                  ),
              ),



              SizedBox(height: 20,),

              ListTile(
                leading: Text("نوع المصروف"),
                title: DropdownButton<String>(
                        value: type,
                        isExpanded: true,
                        hint: Text("اختر نوع المصروف"),
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
                        items: <String>['expenses', 'losses', 'salaries']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value == "expenses" ? "مصاريف" : value == "losses" ? "هوالك"  : "مرتبات"),
                          );
                        }).toList(),
                      ),
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