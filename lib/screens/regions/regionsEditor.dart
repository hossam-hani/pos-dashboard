import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/region.dart';
import '../../services/regions_service.dart';
import '../../validator.dart';

@immutable
class RegionEditorArgumants {
  final Region region;
  final VoidCallback onSaveFinish;
  const RegionEditorArgumants({this.region, this.onSaveFinish});
}

class RegionEditor extends StatefulWidget {
  final RegionEditorArgumants regionArgs;

  const RegionEditor({this.regionArgs});

  @override
  _RegionEditorState createState() => _RegionEditorState();
}

class _RegionEditorState extends State<RegionEditor> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final fees = TextEditingController();
  bool _isActive = true;
  bool _isMainRegion = true;
  bool isLoading = false;
  List<Region> regions;
  Region currentRegion;

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

  Future<void> save() async {
    setState(() => isLoading = true);

    if (_formKey.currentState.validate()) {
      if (!_isMainRegion && currentRegion == null) {
        return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('alert'.tr()),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[Text('region_is_empty_alert'.tr())],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('okay'.tr()),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }

      try {
        await RegionsServices.saveRegion(
          name: name.text,
          regionId: _isMainRegion ? null : currentRegion.id.toString(),
          fees: fees.text,
          isActive: _isActive,
          id: widget.regionArgs == null ? null : widget.regionArgs.region.id.toString(),
        );

        Navigator.pop(context);
        widget.regionArgs?.onSaveFinish?.call();
      } catch (e) {
        /* do nothing */
      }
    }

    setState(() => isLoading = false);
  }

  initValues() async {
    setState(() {
      isLoading = true;
    });

    List<Region> temp = await RegionsServices.getAllMainRegions();

    setState(() {
      regions = temp;
    });

    final region = widget.regionArgs?.region;

    if (region != null) {
      temp.forEach((reg) {
        if (reg.id == reg.id) {
          setState(() {
            currentRegion = reg;
          });
        }
      });

      setState(() {
        name.text = region.name;
        _isMainRegion = region.regionId == null ? true : false;
        fees.text = region.fees == null ? null : region.fees.toString();
        _isActive = region.isActive;
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
      bottomNavigationBar: InkWell(
        onTap: save,
        child: Container(
          height: 80.0,
          decoration: BoxDecoration(color: const Color(0xff1e272e)),
          child: Center(
            child: isLoading
                ? loadingKit
                : Text(
                    "save".tr(),
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.arrowRight, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Image.asset(
          "assets/images/logo.png",
          height: 40,
        ),
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
                  child: Text(
                    widget.regionArgs != null ? "edit_region".tr() : "add_region".tr(),
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
                  hintTxt: "name_hint_region".tr(),
                  labelTxt: "name_label_region".tr(),
                ),
                _isMainRegion
                    ? SizedBox()
                    : CustomeTextField(
                        controller: fees,
                        validator: Validator.notEmpty,
                        hintTxt: "fees_hint_region".tr(),
                        labelTxt: "fees_label_region".tr(),
                      ),
                SizedBox(
                  height: 20,
                ),
                regions == null || _isMainRegion != false
                    ? SizedBox()
                    : DropdownButton<Region>(
                        value: currentRegion,
                        isExpanded: true,
                        items: regions.map((Region region) {
                          return new DropdownMenuItem<Region>(
                            value: region,
                            child: new Text(region.name),
                          );
                        }).toList(),
                        hint: Text("select_region_hint".tr()),
                        onChanged: (newValue) {
                          setState(() {
                            currentRegion = newValue;
                          });
                        },
                      ),
                SizedBox(
                  height: 20,
                ),
                widget.regionArgs != null
                    ? SizedBox()
                    : Row(
                        children: [
                          CupertinoSwitch(
                            value: _isMainRegion,
                            onChanged: (value) {
                              setState(() {
                                _isMainRegion = value;
                              });
                            },
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(_isMainRegion ? "main_region".tr() : "sub_region".tr())
                        ],
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
