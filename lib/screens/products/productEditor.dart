import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io show File;

import 'package:cross_file/cross_file.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:eckit/components/customeButton.dart';
import 'package:eckit/models/Attribute.dart';
import 'package:eckit/models/category.dart';
import 'package:eckit/models/option.dart';
import 'package:eckit/models/product.dart';
import 'package:eckit/services/categories_service.dart';
import 'package:eckit/services/product_service.dart';
import 'package:eckit/utilities/image_picker.dart';

import '../../validator.dart';

@immutable
class ProductEditorArgumants {
  final Product product;
  final VoidCallback onSaveFinish;
  ProductEditorArgumants({
    this.product,
    this.onSaveFinish,
  });
}

class ProductEditor extends StatefulWidget {
  final ProductEditorArgumants productArgs;

  ProductEditor({this.productArgs});

  @override
  _ProductEditorState createState() => _ProductEditorState();
}

class _ProductEditorState extends State<ProductEditor> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final description = TextEditingController();
  final cost = TextEditingController();
  final price = TextEditingController();
  final rank = TextEditingController();
  final priceAfterDiscount = TextEditingController();

  bool _isActive = true;
  bool _stockStatus = true;
  bool isLoading = false;
  String image;
  Category currentCategory;
  String currentUnit;
  List<XFile> images = [];

  List<Attribute> attrbuites = [
    Attribute(title: "Size", isRequired: true, type: "radio", options: [
      Option(title: "Small", description: "small size 50*60", stockStatus: true, addedPrice: 0),
    ]),
    Attribute(title: "extera", isRequired: true, type: "checkbox", options: [])
  ];

  //  File _image;
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

  Future<void> getImage() async {
    final pickedFile = await AppImagePicker().pickImageFile();

    if (pickedFile == null) return;

    setState(() {
      images.add(pickedFile);
    });
  }

  save() async {
    setState(() => isLoading = true);

    if (_formKey.currentState.validate()) {
      List<String> imgsbase64 = [];

      for (final image in images) {
        final imageBytes = await image.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        imgsbase64.add(base64Image);
      }

      try {
        final product = widget.productArgs?.product;
        await ProductServices.saveProduct(
          name: name.text,
          description: description.text,
          isActive: _isActive,
          images: imgsbase64.length > 0 ? imgsbase64 : null,
          id: product == null ? null : product.id.toString(),
          cost: double.parse(cost.text),
          unitType: currentUnit,
          price: double.parse(price.text),
          categoryId: currentCategory.id.toString(),
          priceAfterDiscount: double.tryParse(priceAfterDiscount.text),
          stockStatus: _stockStatus,
          index: int.parse(rank.text),
        );
        Navigator.pop(context);
        widget.productArgs?.onSaveFinish?.call();
      } catch (_) {
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

    List<Category> temp = await CategoryServices.getAllCategories();

    final product = widget.productArgs?.product;

    if (product != null) {
      setState(() {
        name.text = product.name;
        cost.text = product.cost.toString();
        price.text = product.price.toString();
        priceAfterDiscount.text = product.priceAfterDiscount?.toString();
        _stockStatus = product.stockStatus;
        rank.text = product.index.toString();
        description.text = product.description;
        _isActive = product.isActive;
        currentUnit = product.unitType;
        currentCategory = product.category;
        imagesUrl = product.images;
      });
    } else {
      rank.text = "1";
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

  updateWidget() {
    setState(() {});
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
            child: isLoading
                ? SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.productArgs != null ? "edit_product".tr() : "add_product".tr(),
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

                      CustomeTextField(
                        controller: rank,
                        validator: Validator.notEmpty,
                        hintTxt: "rank_hint".tr(),
                        labelTxt: "rank_label".tr(),
                      ),

                      CustomeTextField(
                        controller: priceAfterDiscount,
                        hintTxt: "price_after_discount_hint".tr(),
                        labelTxt: "price_after_discount_label".tr(),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          CupertinoSwitch(
                            value: _stockStatus,
                            onChanged: (value) {
                              setState(() {
                                _stockStatus = value;
                              });
                            },
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(_stockStatus ? "available_in_stock".tr() : "not_available_in_stock".tr())
                        ],
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

                      //   ExpansionTile(
                      //   title: Text("advance_option".tr()),
                      //   children: [
                      //   ... attrbuites.map((attrbuite) => AttributeW(
                      //     title: attrbuite.title,
                      //     type: attrbuite.type,
                      //     isRequired: attrbuite.isRequired,
                      //     attribute: attrbuite,
                      //     updateWidget: updateWidget,
                      //   )).toList(),
                      //   CustomeButton(title: "add_new_attribute",icon: FontAwesomeIcons.plus ),
                      //   ],
                      //  ),

                      SizedBox(
                        height: 20,
                      ),
                      images.length != 0
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: FlatButton(onPressed: getImage, child: Text("اختر المزيد من الصور")),
                            )
                          : InkWell(
                              onTap: getImage,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
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
                                                _buildImage(e),
                                                SizedBox(height: 5),
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
                                                          color: const Color(0xffffffff),
                                                          fontWeight: FontWeight.w300,
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      color: const Color(0xffff6a37),
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
                                                    padding: const EdgeInsets.all(8.0),
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
                                                                style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: const Color(0xffffffff),
                                                                  fontWeight: FontWeight.w300,
                                                                ),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                            ),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                              color: const Color(0xffff6a37),
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

class AttributeW extends StatelessWidget {
  String title;
  bool isRequired;
  String type;
  Attribute attribute;
  dynamic updateWidget;

  AttributeW({this.title, this.isRequired, this.type, this.attribute, this.updateWidget});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomeTextField(
          validator: Validator.notEmpty,
          hintTxt: "attribute_hint".tr(),
          labelTxt: "attribute_label".tr(),
          controller: TextEditingController(text: title),
          changeHandler: (newVal) => attribute.setTitle = newVal,
        ),
        SizedBox(
          height: 10,
        ),
        CustomeSwitchW(
            option1: "is_required".tr(),
            option2: "is_not_required".tr(),
            initValue: attribute.isRequired,
            changeHandler: (newValue) => attribute.setIsRequired = newValue),
        CustomeSwitchW(
            option1: "radio".tr(),
            option2: "checkbox".tr(),
            trackColor: Colors.blue,
            activeColor: Colors.pink,
            initValue: attribute.type == "radio",
            changeHandler: (newValue) => attribute.setIsRequired = newValue),
        attribute.options == null
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ...attribute.options
                        .map((option) => OptionW(
                            title: option.title,
                            stockStatus: option.stockStatus,
                            description: option.description,
                            addedPrice: option.addedPrice.toString(),
                            option: option,
                            deleteHandler: attribute.removeOption,
                            updateWidget: updateWidget,
                            index: attribute.options.indexOf(option)))
                        .toList()
                  ],
                ),
              ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 200,
          child: CustomeButton(
              title: "add_option",
              icon: FontAwesomeIcons.plus,
              handler: () {
                attribute.addOption();
                updateWidget();
              }),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class OptionW extends StatelessWidget {
  String title;
  String addedPrice;
  String description;
  bool stockStatus;
  Option option;
  dynamic deleteHandler;
  dynamic updateWidget;
  int index;

  OptionW(
      {this.addedPrice,
      this.title,
      this.stockStatus,
      this.description,
      this.option,
      this.updateWidget,
      this.deleteHandler,
      this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomeTextField(
          validator: Validator.notEmpty,
          hintTxt: "option_hint".tr(),
          labelTxt: "option_label".tr(),
          controller: TextEditingController(text: option.title),
          changeHandler: (newVal) => option.setTitle = newVal,
        ),
        CustomeTextField(
          validator: Validator.notEmpty,
          hintTxt: "option_hint_des".tr(),
          labelTxt: "option_label_des".tr(),
          controller: TextEditingController(text: option.description),
          changeHandler: (newVal) => option.setDescription = newVal,
        ),
        CustomeTextField(
          validator: Validator.notEmpty,
          hintTxt: "added_price_hint".tr(),
          labelTxt: "added_price_label".tr(),
          controller: TextEditingController(
            text: option.addedPrice == null ? null : option.addedPrice.toString(),
          ),
          changeHandler: (newVal) => option.setAddedPrice = newVal,
        ),
        SizedBox(
          height: 10,
        ),
        CustomeSwitchW(
            option1: "available_in_stock".tr(),
            option2: "not_available_in_stock".tr(),
            initValue: stockStatus,
            changeHandler: (newValue) => option.setNewStockStatus = newValue),
        CustomeButton(
          title: "delete".tr(),
          icon: FontAwesomeIcons.trash,
          handler: () {
            deleteHandler(index);
            updateWidget();
          },
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class CustomeSwitchW extends StatefulWidget {
  String option1;
  String option2;
  dynamic changeHandler;
  bool initValue;
  Color trackColor;
  Color activeColor;

  CustomeSwitchW(
      {this.option1,
      this.option2,
      this.changeHandler,
      this.initValue,
      this.activeColor = Colors.green,
      this.trackColor = Colors.grey});

  @override
  _CustomeSwitchWState createState() => _CustomeSwitchWState();
}

class _CustomeSwitchWState extends State<CustomeSwitchW> {
  bool initValue;

  @override
  void initState() {
    super.initState();
    setState(() {
      initValue = widget.initValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CupertinoSwitch(
              trackColor: widget.trackColor,
              activeColor: widget.activeColor,
              value: initValue,
              onChanged: (value) {
                widget.changeHandler(value);
                setState(() {
                  initValue = value;
                });
              },
            ),
            SizedBox(
              width: 15,
            ),
            Text(initValue ? widget.option1 : widget.option2)
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class CustomeTextField extends StatelessWidget {
  String hintTxt;
  String labelTxt;
  TextEditingController controller;
  dynamic validator;
  dynamic changeHandler;
  bool obscureTextbool;
  bool isNumber;

  CustomeTextField(
      {this.hintTxt,
      this.labelTxt,
      this.controller,
      this.validator,
      this.obscureTextbool = false,
      this.isNumber = false,
      this.changeHandler});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      obscureText: obscureTextbool,
      validator: validator,
      controller: controller,
      onChanged: (newVal) => changeHandler?.call(newVal),
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
