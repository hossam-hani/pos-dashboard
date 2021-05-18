
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:eckit/models/account.dart';
import 'package:eckit/models/category.dart';
import 'package:eckit/models/store.dart';
import 'package:eckit/models/supplier.dart';
import 'package:eckit/services/account_service.dart';
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

class UsersEditor extends StatefulWidget {

  User user;

  UsersEditor({this.user});

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

      await AccountService.saveUser(
        name: name.text,
        email: email.text,
        password: password.text,
        phone: phone.text,
        role: currentRole,
        isBlocked: _isBlocked,
        id:widget.user == null ? null : widget.user.id.toString()
        );

    }

    setState(() {
      isLoading = false;
    });

  }

  initValues() async {
  
  setState(() {
      isLoading = true;
  });


  if(widget.user != null){

    setState(() {
      name.text = widget.user.name;
      email.text = widget.user.email;
      phone.text = widget.user.phone;
      currentRole = widget.user.role;
      _isBlocked = widget.user.isBlocked;
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
                    widget.user != null ? "edit_user".tr() : "add_user".tr(),
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
                  hintTxt: "name_hint_user".tr(),
                  labelTxt: "name_label_user".tr(),
                ),

                CustomeTextField(
                  controller:  email,
                  validator: Validator.notEmpty,
                  hintTxt: "email_hint_user".tr(),
                  labelTxt: "email_label_user".tr(),
                ),

               widget.user != null ? SizedBox() : CustomeTextField(
                  controller:  password,
                  validator: Validator.notEmpty,
                  hintTxt: "password_hint_user".tr(),
                  labelTxt: "password_label_user".tr(),
                ),
                
                CustomeTextField(
                  controller:  phone,
                  validator: Validator.notEmpty,
                  hintTxt: "phone_hint_user".tr(),
                  labelTxt: "phone_label_user".tr(),
                ),

              SizedBox(height: 10,),

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
             SizedBox(height: 20,),

                widget.user == null ? SizedBox() : Row(children: [
    
                CupertinoSwitch(
                  value: _isBlocked,
                  onChanged: (value) {
                    setState(() {
                      _isBlocked = value;
                    });
                  },
                ),

                SizedBox(width: 15,),

                Text(_isBlocked ? "blockead".tr() : "active".tr())

                ],),
  
                
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