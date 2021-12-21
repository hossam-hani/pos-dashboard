import 'dart:convert';
import 'dart:io' as io show File;

import 'package:cross_file/cross_file.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:eckit/models/category.dart';
import 'package:eckit/services/categories_service.dart';
import 'package:eckit/utilities/image_picker.dart';

import '../../validator.dart';

@immutable
class CategoryEditorArgumants {
  final Category category;
  final VoidCallback onSaveFinish;
  const CategoryEditorArgumants({
    this.category,
    this.onSaveFinish,
  });
}

class CategoryEditor extends StatefulWidget {
  final CategoryEditorArgumants categoryArgs;

  CategoryEditor({this.categoryArgs});

  @override
  _CategoryEditorState createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<CategoryEditor> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();
  bool _isActive = true;
  bool isLoading = false;
  String imageUrl;

  XFile _image;

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

  Future getImage() async {
    final pickedFile = await AppImagePicker().pickImageFile();

    if (mounted)
      setState(() {
        if (pickedFile != null) {
          _image = pickedFile;
        } else {
          print('No image selected.');
        }
      });
  }

  Future<void> save() async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState.validate()) {
      String base64Image;

      if (_image != null) {
        final imageBytes = await _image.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      try {
        await CategoryServices.saveCategory(
          name: name.text,
          description: description.text,
          isActive: _isActive,
          image: base64Image,
          id: widget.categoryArgs?.category?.id?.toString(),
        );
        Navigator.pop(context);
        widget.categoryArgs.onSaveFinish?.call();
      } catch (e) {
        /* do nothing */
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  initValues() {
    final category = widget.categoryArgs?.category;

    if (category != null) {
      setState(() {
        name.text = category.name;
        description.text = category.description;
        _isActive = category.isActive;
        imageUrl = category.image;
      });
    }
  }

  @override
  void initState() {
    initValues();
    super.initState();
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
                    widget.categoryArgs != null ? "edit_category".tr() : "add_category".tr(),
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
                  hintTxt: "name_hint_category".tr(),
                  labelTxt: "name_label_category".tr(),
                ),
                CustomeTextField(
                  controller: description,
                  validator: Validator.notEmpty,
                  hintTxt: "description_hint_category".tr(),
                  labelTxt: "description_label_category".tr(),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    CupertinoSwitch(
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(_isActive ? "active".tr() : "not_active".tr())
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (_image != null || imageUrl != null)
                  _image != null ? _buildImage(_image) : Image.network(imageUrl)
                else
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
                        ],
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(XFile imageFile) {
    if (kIsWeb) {
      return Image.network(
        imageFile.path,
        width: 100,
        height: 100,
      );
    } else {
      return Image.file(
        io.File(imageFile.path),
        width: 100,
        height: 100,
      );
    }
  }
}

class CustomeTextField extends StatelessWidget {
  final String hintTxt;
  final String labelTxt;
  final TextEditingController controller;
  final dynamic validator;
  final bool obscureTextbool;

  CustomeTextField({
    this.hintTxt,
    this.labelTxt,
    this.controller,
    this.validator,
    this.obscureTextbool = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureTextbool,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
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
        ),
      ),
    );
  }
}
