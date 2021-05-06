import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:eckit/validator.dart';

import 'package:eckit/models/boot_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountDetails extends StatefulWidget {
  BootData bootData;

  AccountDetails({this.bootData});
  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {

  String currentCategory;
  BootData bootdata;
  bool isLoading = false;

  Future checkAccountDetails(String phone,String email) async {
    
   Response response =  await Dio().post("$baseUrl/user/check/account",data: {
      "phone" : phone,
      "email" : email,
    });

    print(response.data);

    return response.data;
  }
  

  // form
  final _formKey = GlobalKey<FormState>();
  TextEditingController accountName = new TextEditingController();
  TextEditingController accountEmail = new TextEditingController();
  TextEditingController accountPhone = new TextEditingController();
  TextEditingController accountPassword = new TextEditingController();
  String code;

  next() async {
    if (_formKey.currentState.validate()) {
      if(code == null){
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
      dynamic accountCheck = await checkAccountDetails(code + accountPhone.text,accountEmail.text);
      if(!accountCheck["email_availability"] ||  !accountCheck["phone_availability"]){
      showDialog(
        context: context,
        builder: (_) => new AlertDialog(
            title: new Text("alert").tr(),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              accountCheck["email_availability"] ? SizedBox() : Text("email_is_registered_before").tr(),
              accountCheck["phone_availability"] ? SizedBox() : Text("phone_is_registered_before").tr(),
            ],),
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
       await prefs.setString('name', accountName.text);
       await prefs.setString('email', accountEmail.text);
       await prefs.setString('phone', accountPhone.text);
       await prefs.setString('code', code);
       await prefs.setString('password', accountPassword.text);

      }
       Navigator.pushReplacementNamed(context, '/create_account');
      }
    }
  }



  initAccountDetails() async{
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name_temp = prefs.getString("name");
    String email_temp = prefs.getString("email");
    String temp_phone = prefs.getString("phone");
    String code_temp = prefs.getString("code");

    setState(() {
      accountName.text = name_temp;
      accountEmail.text = email_temp;
      accountPhone.text = temp_phone;
      code = code_temp;
      isLoading = false;
    });

  }

  @override 
  void initState() {
    super.initState();
    initAccountDetails();
  }

  @override
  Widget build(BuildContext context) {

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
            title:Image.asset("assets/images/logo.png" , height: 40,)
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
                'last_step_to_build_your_account'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  color: const Color(0xff1d1c1c),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),

              CustomeTextField(
                controller:  accountName,
                validator: Validator.notEmpty,
                hintTxt: "account_name_hint".tr(),
                labelTxt: "account_name_label".tr(),
              ),

              CustomeTextField(
                controller:  accountEmail,
                validator: Validator.notEmpty,
                hintTxt: "account_email_hint".tr(),
                labelTxt: "account_email_label".tr(),
              ),



              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(children: [
                

                SizedBox(
                  width: 130,
                  child: new DropdownButton<String>(
                  iconEnabledColor: mainColor,
                  hint: Text("select_country_key").tr(),
                  isExpanded: true,
                  value: code,
                  items: widget.bootData.countries.map((Countries value) {
                    return new DropdownMenuItem<String>(
                      value: value.code,
                      child: Row(children: [
                        Image.network(value.flagImg),
                        SizedBox(width: 10,),
                        new Text(" (" + value.code + ") ")
                      ],),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      code = newValue;
                    });
                  },
                  ),
                ),


              Expanded(
                  child: CustomeTextField(
                  controller:  accountPhone,
                  validator: Validator.notEmpty,
                  hintTxt: "account_phone_hint".tr(),
                  labelTxt: "account_phone_label".tr(),
                ),
               ),
              ],)
              ),

             
              CustomeTextField(
                controller:  accountPassword,
                validator: Validator.notEmpty,
                hintTxt: "account_password_hint".tr(),
                labelTxt: "account_password_label".tr(),
                obscureTextbool: true,
              ),

              SizedBox(height: 30,),

              Text(
                'confirm_rule_of_registration'.tr(),
                style: TextStyle(
                  fontSize: 15,
                  color: const Color(0xff1d1c1c),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
              
              SizedBox(
              child: Text(
                widget.bootData.registrationRules,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xffc7c5c5),
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.right,
              ),
            )

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