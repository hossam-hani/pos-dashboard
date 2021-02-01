import 'package:dio/dio.dart';
import 'package:eckit/validator.dart';
import 'package:flutter/material.dart';

import 'package:eckit/models/boot_data.dart';
import 'package:eckit/services/boot_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';
import 'package:easy_localization/easy_localization.dart';

class ShopDetails extends StatefulWidget {
  BootData bootData;

  ShopDetails({this.bootData});
  @override
  _ShopDetailsState createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {

  String currentCategory;
  BootData bootdata;
  bool isLoading = false;

  // form
  final _formKey = GlobalKey<FormState>();
  TextEditingController storeName = new TextEditingController();
  TextEditingController storeLink = new TextEditingController();
  String country;
  String curreny;



  initShopDetails() async{
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeName_temp = prefs.getString("storeName");
    String storeLink_temp = prefs.getString("storeLink");
    String country_temp = prefs.getString("country");
    String curreny_temp = prefs.getString("curreny");

    setState(() {
      storeName.text = storeName_temp;
      storeLink.text = storeLink_temp;
      country = country_temp;
      curreny = curreny_temp;
      isLoading = false;
    });

  }


  Future<bool> checkShopLink(String shopLink) async {
   Response response =  await Dio().post("$baseUrl/user/check/shop",data: {
      "shop_link" : shopLink
    });

    return response.data["availability"];
  }
  

  @override 
  void initState() {
    super.initState();
    initShopDetails();
  }

  @override
  Widget build(BuildContext context) {

  next() async {
    if (_formKey.currentState.validate()) {
      if(curreny == null || country == null){
        
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              title: new Text("alert").tr(),
              content: new Text("alert_about_complete_data").tr(),
              actions: <Widget>[
                FlatButton(
                  child: Text('close').tr(),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));

      }else{
        if(!await checkShopLink(storeLink.text)){
                  showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              title: new Text("alert").tr(),
              content: new Text("this_link_not_avalible").tr(),
              actions: <Widget>[
                FlatButton(
                  child: Text('close').tr(),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
        }else{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('storeName', storeName.text);
          await prefs.setString('storeLink', storeLink.text);
          await prefs.setString('country', country);
          await prefs.setString('curreny', curreny);

          Navigator.pushNamed(context, "/account_details",arguments: widget.bootData);
        }

      }
    }
  }



    var ladingKit = Center(
          child: SpinKitSquareCircle(
            color: mainColor,
            size: 50.0,
          ),
        );

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 100,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title:Image.asset("assets/images/logo.png" , height: 70,)
          ,),
          backgroundColor: Colors.white,
          bottomNavigationBar: InkWell(
            onTap: next,
            child: Container(
            child: Center(
              child: Text(
                'next',
                style: TextStyle(
                  fontSize: 25,
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ).tr(),
            ),
            width: double.infinity,
            height: 66.0,
            decoration: BoxDecoration(
              color: mainColor,
            ),
          ),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
            child: isLoading  ? ladingKit : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

            Text(
                'enter_shop_details'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  color: const Color(0xff1d1c1c),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),

              CustomeTextField(
                controller:  storeName,
                validator: Validator.notEmpty,
                hintTxt: "storename_hint".tr(),
                labelTxt: "storename_label".tr(),
              ),

              CustomeTextField(
                controller: storeLink,
                validator: Validator.notEmpty,
                hintTxt: "storelink_hint".tr(),
                labelTxt: "storelink_label".tr(),
              ),

              Text(
                storeLink.text == "" ? widget.bootData.websiteLink.replaceAll("websitelink", "example") :  widget.bootData.websiteLink.replaceAll("websitelink", storeLink.text),
                style: TextStyle(
                  fontSize: 15,
                  color: const Color(0xffc2bcbc),
                ),
                textAlign: TextAlign.left,
              ),

              

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: new DropdownButton<String>(
                iconEnabledColor: mainColor,
                hint: Text("select_county").tr(),
                isExpanded: true,
                value: country,
                items: widget.bootData.countries.map((Countries value) {
                  return new DropdownMenuItem<String>(
                    value: value.country,
                    child: Row(children: [
                      Image.network(value.flagImg),
                      SizedBox(width: 10,),
                      new Text(value.countryName)
                    ],),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    country = newValue;
                  });
                },
            ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: new DropdownButton<String>(
                iconEnabledColor: mainColor,
                hint: Text("select_curreny").tr(),
                isExpanded: true,
                value: curreny,
                items: widget.bootData.countries.map((Countries value) {
                  return new DropdownMenuItem<String>(
                    value: value.currency,
                    child: Row(children: [
                      Image.network(value.flagImg),
                      SizedBox(width: 10,),
                      new Text(value.currency)
                    ],),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    curreny = newValue;
                  });
                },
            ),
              ),
        ],),
      ),
    ),
          ),);
  }
}


class CustomeTextField extends StatelessWidget {
  String hintTxt;
  String labelTxt;
  TextEditingController controller;
  dynamic validator;

  CustomeTextField({this.hintTxt,this.labelTxt,this.controller,this.validator});

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
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