import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:eckit/models/category.dart';
import 'package:eckit/models/product.dart';
import 'package:eckit/services/categories_service.dart';
import 'package:eckit/services/product_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../../validator.dart';

class ProductEditor extends StatefulWidget {
  Product product;

  ProductEditor({this.product});

  @override
  _ProductEditorState createState() => _ProductEditorState();
}

class _ProductEditorState extends State<ProductEditor> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController cost = new TextEditingController();
  TextEditingController price = new TextEditingController();

  bool _isActive = true;
  bool isLoading = false;
  String image;
  Category currentCategory;
  String currentUnit;
  List<File> images = [];

  //  File _image;
  final picker = ImagePicker();
  //  List<Asset> images = new List<Asset>();

  List<Category> categories;

  List<dynamic> imagesUrl;

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

  Future<File> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  addnewImageToList() async {
    File temp = await getImage();
    setState(() {
      images.add(temp);
    });
  }

  save() async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState.validate()) {
      List<String> imgsbase64 = [];

      for (var image in images) {
        List<int> imageBytes = await image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        imgsbase64.add(base64Image);
      }

      await ProductServices.saveProduct(
        name: name.text,
        description: description.text,
        isActive: _isActive,
        images: imgsbase64.length > 0 ? imgsbase64 : null,
        id: widget.product == null ? null : widget.product.id.toString(),
        cost: double.parse(cost.text),
        unitType: currentUnit,
        price: double.parse(price.text),
        categoryId: currentCategory.id.toString(),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  //   Future<void> loadAssets() async {
  //   List<Asset> resultList;

  //   try {
  //     resultList = await MultiImagePicker.pickImages(
  //       maxImages: 300,
  //       enableCamera: true,
  //       selectedAssets: images,
  //       cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
  //       materialOptions: MaterialOptions(
  //         actionBarColor: "#abcdef",
  //         actionBarTitle: "Example App",
  //         allViewTitle: "All Photos",
  //         useDetailsView: false,
  //         selectCircleStrokeColor: "#000000",
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     print(e);
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     images = resultList;
  //   });
  // }

  initValues() async {
    setState(() {
      isLoading = true;
    });

    List<Category> temp = await CategoryServices.getAllCategories();

    if (widget.product != null) {
      setState(() {
        name.text = widget.product.name;
        cost.text = widget.product.cost.toString();
        price.text = widget.product.price.toString();
        description.text = widget.product.description;
        _isActive = widget.product.isActive;
        currentUnit = widget.product.unitType;
        currentCategory = widget.product.category;
        imagesUrl = widget.product.images;
      });
    }

    setState(() {
      categories = temp;
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
            icon: FaIcon(FontAwesomeIcons.arrowRight, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Image.asset(
            "assets/images/logo.png",
            height: 70,
          )),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.product != null
                              ? "edit_product".tr()
                              : "add_product".tr(),
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
                        hintTxt: "name_hint".tr(),
                        labelTxt: "name_label".tr(),
                      ),
                      CustomeTextField(
                        controller: cost,
                        validator: Validator.notEmpty,
                        isNumber: true,
                        hintTxt: "cost_hint".tr(),
                        labelTxt: "cost_label".tr(),
                      ),
                      CustomeTextField(
                        controller: price,
                        isNumber: true,
                        validator: Validator.notEmpty,
                        hintTxt: "price_hint".tr(),
                        labelTxt: "price_label".tr(),
                      ),
                      CustomeTextField(
                        controller: description,
                        validator: Validator.notEmpty,
                        hintTxt: "description_hint".tr(),
                        labelTxt: "description_label".tr(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      categories == null
                          ? SizedBox()
                          : DropdownButton<Category>(
                              value: currentCategory,
                              isExpanded: true,
                              items: categories.map((Category category) {
                                return new DropdownMenuItem<Category>(
                                  value: category,
                                  child: new Text(category.name),
                                );
                              }).toList(),
                              hint: Text("select_category_hint".tr()),
                              onChanged: (newValue) {
                                setState(() {
                                  currentCategory = newValue;
                                });
                              },
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownButton<String>(
                        value: currentUnit,
                        isExpanded: true,
                        items: <String>['KG', 'Unit', 'L'].map((String unit) {
                          return new DropdownMenuItem<String>(
                            value: unit,
                            child: new Text(unit.tr()),
                          );
                        }).toList(),
                        hint: Text("select_unit_hint".tr()),
                        onChanged: (newValue) {
                          setState(() {
                            currentUnit = newValue;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
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
                      images.length != 0
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: FlatButton(
                                  onPressed: addnewImageToList,
                                  child: Text("اختر المزيد من الصور")),
                            )
                          : InkWell(
                              onTap: addnewImageToList,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.images,
                                        color: Color(0xFFFF6A37),
                                        size: 40,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'select_image'.tr(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: const Color(0xffadadad),
                                        ),
                                        textAlign: TextAlign.left,
                                      )
                                    ],
                                  ),
                                  width: double.infinity,
                                  height: 131.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: const Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29c2bcbc),
                                        offset: Offset(0, 3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      images.length != 0
                          ? Container(
                              height: 160,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  ...images
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Image.file(
                                                  e,
                                                  width: 100,
                                                  height: 100,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      images.remove(e);
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 72.0,
                                                    height: 33.0,
                                                    child: Center(
                                                      child: Text(
                                                        'حذف',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: const Color(
                                                              0xffffffff),
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      color: const Color(
                                                          0xffff6a37),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ],
                              ),
                            )
                          : SizedBox(),
                      Divider(),
                      imagesUrl == null
                          ? SizedBox()
                          : imagesUrl.length != 0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("الصور السابقة"),
                                    Container(
                                      height: 160,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          ...imagesUrl
                                              .map((e) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        Image.network(
                                                          e.imageUrl,
                                                          width: 100,
                                                          height: 100,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            // setState(() {
                                                            //   images.remove(e);
                                                            // });
                                                          },
                                                          child: Container(
                                                            width: 72.0,
                                                            height: 33.0,
                                                            child: Center(
                                                              child: Text(
                                                                'حذف',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  color: const Color(
                                                                      0xffffffff),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              color: const Color(
                                                                  0xffff6a37),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ))
                                              .toList(),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
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
  bool isNumber;

  CustomeTextField(
      {this.hintTxt,
      this.labelTxt,
      this.controller,
      this.validator,
      this.obscureTextbool = false,
      this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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
