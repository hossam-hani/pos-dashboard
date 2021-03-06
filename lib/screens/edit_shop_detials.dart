import 'dart:convert';
import 'dart:io' as io show File;

import 'package:cross_file/cross_file.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eckit/utilities/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:eckit/models/account.dart';
import 'package:eckit/services/shop_service.dart';

class ShopDetials extends StatefulWidget {
  ShopDetials();

  @override
  _ShopDetialsState createState() => _ShopDetialsState();
}

class _ShopDetialsState extends State<ShopDetials> {
  final _formKey = GlobalKey<FormState>();
  final whatsappnumber = TextEditingController();
  final phonenumber = TextEditingController();
  final fbLink = TextEditingController();
  final instaLink = TextEditingController();
  final descriptionLink = TextEditingController();
  final gaId = TextEditingController();
  final pixelId = TextEditingController();

  bool _isActive = true;
  bool isLoading = false;
  bool initLoading = true;

  String image1;
  XFile _image1;

  String image2;
  XFile _image2;

  String image3;
  XFile _image3;

  String image4;
  XFile _image4;

  String image5;
  XFile _image5;

  String image6;
  XFile _image6;

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

  Future getImage(int index) async {
    final pickedFile = await AppImagePicker().pickImageFile();

    setState(() {
      if (pickedFile != null) {
        if (index == 1) {
          _image1 = pickedFile;
        } else if (index == 2) {
          _image2 = pickedFile;
        } else if (index == 3) {
          _image3 = pickedFile;
        } else if (index == 4) {
          _image4 = pickedFile;
        } else if (index == 5) {
          _image5 = pickedFile;
        } else if (index == 6) {
          _image6 = pickedFile;
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> convertImageToBase64(XFile imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  save() async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState.validate()) {
      String base64Image1 = _image1 != null ? await convertImageToBase64(_image1) : null;
      String base64Image2 = _image2 != null ? await convertImageToBase64(_image2) : null;
      String base64Image3 = _image3 != null ? await convertImageToBase64(_image3) : null;
      String base64Image4 = _image4 != null ? await convertImageToBase64(_image4) : null;
      String base64Image5 = _image5 != null ? await convertImageToBase64(_image5) : null;
      String base64Logo = _image6 != null ? await convertImageToBase64(_image6) : null;

      //update from service
      await ShopService.saveDetails(
          facebook_link: fbLink.text,
          instagram_link: instaLink.text,
          description: descriptionLink.text,
          whatsapp_contact: whatsappnumber.text,
          phone_number: phonenumber.text,
          sliderimage_1: base64Image1,
          sliderimage_2: base64Image2,
          sliderimage_3: base64Image3,
          sliderimage_4: base64Image4,
          sliderimage_5: base64Image5,
          gaId: gaId.text,
          pixelId: pixelId.text,
          isActive: _isActive,
          logo: base64Logo);
    }

    setState(() {
      isLoading = false;
    });
  }

  initValues() async {
    setState(() {
      isLoading = true;
    });

    Shop shop = await ShopService.getShopDetials();

    print(shop.whatsappContact);

    setState(() {
      isLoading = false;

      whatsappnumber.text = shop.whatsappContact;
      phonenumber.text = shop.phoneNumber;
      fbLink.text = shop.facebookLink;
      instaLink.text = shop.instagramLink;
      descriptionLink.text = shop.description;
      _isActive = shop.isActive;
      gaId.text = shop.gaId;
      pixelId.text = shop.pixelId;
      image6 = shop.logo;
      image1 = shop.sliderimage1;
      image2 = shop.sliderimage2;
      image3 = shop.sliderimage3;
      image4 = shop.sliderimage4;
      image5 = shop.sliderimage5;
      initLoading = false;
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
      body: initLoading
          ? loadingKit
          : SingleChildScrollView(
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
                          'edit_shop_detials'.tr(),
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CustomeTextField(
                        controller: whatsappnumber,
                        hintTxt: "whatsapp_contact_hint".tr(),
                        labelTxt: "whatsapp_contact_label".tr(),
                      ),
                      CustomeTextField(
                        controller: phonenumber,
                        hintTxt: "phone_number_hint".tr(),
                        labelTxt: "phone_number_label".tr(),
                      ),
                      CustomeTextField(
                        controller: fbLink,
                        hintTxt: "facebook_link_hint".tr(),
                        labelTxt: "facebook_link_label".tr(),
                      ),
                      CustomeTextField(
                        controller: instaLink,
                        hintTxt: "instagram_link_hint".tr(),
                        labelTxt: "instagram_link_label".tr(),
                      ),
                      CustomeTextField(
                        controller: descriptionLink,
                        hintTxt: "store_des_hint".tr(),
                        labelTxt: "store_des".tr(),
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
                      Divider(),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "analysis_integration".tr(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Divider(),
                      CustomeTextField(
                        controller: gaId,
                        hintTxt: "ga_id_hint".tr(),
                        labelTxt: "ga_id_des".tr(),
                      ),
                      CustomeTextField(
                        controller: pixelId,
                        hintTxt: "fb_id_hint".tr(),
                        labelTxt: "fb_id_des".tr(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Logo".tr(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ImageSelector(
                        changeImageHandler: getImage,
                        image: image6,
                        imageFile: _image6,
                        index: 6,
                      ),
                      Divider(),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Slider".tr(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ImageSelector(
                        changeImageHandler: getImage,
                        image: image1,
                        imageFile: _image1,
                        index: 1,
                      ),
                      ImageSelector(
                        changeImageHandler: getImage,
                        image: image2,
                        imageFile: _image2,
                        index: 2,
                      ),
                      ImageSelector(
                        changeImageHandler: getImage,
                        image: image3,
                        imageFile: _image3,
                        index: 3,
                      ),
                      ImageSelector(
                        changeImageHandler: getImage,
                        image: image4,
                        imageFile: _image4,
                        index: 4,
                      ),
                      ImageSelector(
                        changeImageHandler: getImage,
                        image: image5,
                        imageFile: _image5,
                        index: 5,
                      )
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

class ImageSelector extends StatelessWidget {
  dynamic changeImageHandler;
  String image;
  XFile imageFile;
  int index;

  ImageSelector({
    this.changeImageHandler,
    this.image,
    this.imageFile,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageFile != null || image != null)
            imageFile != null ? _buildImage(imageFile) : Image.network(image)
          else
            InkWell(
              onTap: () => changeImageHandler(index),
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
          imageFile != null
              ? SizedBox()
              : FlatButton(onPressed: () => changeImageHandler(index), child: Text("change_image".tr()))
        ],
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
