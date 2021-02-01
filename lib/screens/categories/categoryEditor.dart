
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:eckit/models/category.dart';
import 'package:eckit/services/categories_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';

import '../../const.dart';
import '../../validator.dart';


class CategoryEditor extends StatefulWidget {

  Category category;

  CategoryEditor({this.category});

  @override
  _CategoryEditorState createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<CategoryEditor> {
  
   final _formKey = GlobalKey<FormState>();
   TextEditingController name = new TextEditingController();
   TextEditingController description = new TextEditingController();
   bool _isActive = true;
   bool isLoading = false;
   String image;

   File _image;
   final picker = ImagePicker();


  var loadingKit = Center(
        child: Column(children: [
          SizedBox(height: 20,),
          SpinKitSquareCircle(
          color: Colors.white,
          size: 50.0,
        ),
        ],),
      );
      
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  save() async {

    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState.validate()) {
       String base64Image;

      if(_image != null){
        List<int> imageBytes = await _image.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
      }

      await CategoryServices.saveCategory(name: name.text, description : description.text,
        isActive: _isActive, image: base64Image, id: widget.category == null ? null : widget.category.id.toString());

    }

    setState(() {
      isLoading = false;
    });

  }

  initValues(){
  
  if(widget.category != null){
    setState(() {
      name.text = widget.category.name;
      description.text = widget.category.description;
      _isActive = widget.category.isActive;
      image = widget.category.image;
    });
  }

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
                    widget.category != null ? "edit_category".tr() : "add_category".tr(),
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
                  hintTxt: "name_hint".tr(),
                  labelTxt: "name_label".tr(),
                ),


                CustomeTextField(
                  controller:  description,
                  validator: Validator.notEmpty,
                  hintTxt: "description_hint".tr(),
                  labelTxt: "description_label".tr(),
                ),

              SizedBox(height: 20,),

                Row(children: [
    
                CupertinoSwitch(
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),

                SizedBox(width: 15,),

                Text(_isActive ? "active".tr() : "not_active".tr())

                ],),

              SizedBox(height: 20,),


                 _image != null || image != null ? _image != null ? Image.file(_image) : Image.network(image) :  
                 InkWell(
                  onTap: getImage,
                  child: Container(
                  width: double.infinity,
                  height: 150.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                    Text(
                      'select_image_category'.tr(),
                      style: TextStyle(
                        fontSize: 15,
                        color: const Color(0xff474747),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    Text(
                        'select_image_des'.tr(),
                        style: TextStyle(
                          fontSize: 10,
                          color: const Color(0xff7a7171),
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.left,
                      )

                  ],),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x29bbb8b8),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),

              FlatButton(onPressed: getImage, child: Text("change_image".tr()))

              


                
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