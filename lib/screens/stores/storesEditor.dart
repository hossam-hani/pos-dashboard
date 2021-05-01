
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:eckit/models/category.dart';
import 'package:eckit/models/store.dart';
import 'package:eckit/services/categories_service.dart';
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

class StoreEditor extends StatefulWidget {

  Store store;

  StoreEditor({this.store});

  @override
  _StoreEditorState createState() => _StoreEditorState();
}


class _StoreEditorState extends State<StoreEditor> {
  
   final _formKey = GlobalKey<FormState>();
   TextEditingController name = new TextEditingController();
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
      await StoreServices.saveStore(name: name.text, id: widget.store == null ? null : widget.store.id.toString());
    }

    setState(() {
      isLoading = false;
    });

  }

  initValues() async {
  
  setState(() {
      isLoading = true;
  });


  if(widget.store != null){

    setState(() {
      name.text = widget.store.name;
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
                    widget.store != null ? "edit_store".tr() : "add_store".tr(),
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
                  hintTxt: "name_hint_store".tr(),
                  labelTxt: "name_label_store".tr(),
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