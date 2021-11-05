import 'package:eckit/models/address.dart';
import 'package:eckit/models/customer.dart';
import 'package:eckit/models/items.dart';
import 'package:eckit/models/order.dart';
import 'package:eckit/services/customer_service.dart';
import 'package:eckit/services/orders_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../components/customeButton.dart';
import 'package:paging/paging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product.dart';
import '../../const.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../validator.dart';
import 'package:timeago/timeago.dart' as timeago;

class CustomersReport extends StatefulWidget {


  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomersReport> {

  List<Customer> customers = [];
  int currentPage = 1;
  bool isLoading = false;
  TextEditingController keyword = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String totalBalance;

  var loadingKit = Center(
        child: Column(children: [
          SizedBox(height: 20,),
          SpinKitSquareCircle(
          color: mainColor,
          size: 50.0,
        ),
        SizedBox(height: 10,),
        Text("loading".tr())
        ],),
      );

  Future<List<Customer>> getProductsLocal() async {

    List<Customer> temp = await CustomerServices.getCustomers(currentPage.toString(),null);

    setState(() {
      customers = customers.isEmpty ? temp : customers;
      currentPage = currentPage+1;
      isLoading = false;
    });
    
    return temp;
    
  }

  getBalanceOfCustomer() async {
      String valTemp = await CustomerServices.getCustomerBalance();
      setState(() {
          totalBalance = valTemp;
        });
  }

  @override
  void initState() {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    getBalanceOfCustomer();
    
    super.initState();
    setState(() {
      isLoading =  true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          body: SafeArea(
                
                child: Padding(
                  padding:  EdgeInsets.all(0 ),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  Row(children: [
                  FaIcon(FontAwesomeIcons.users),
                  SizedBox(width: 10,),
                  Text("customers".tr(),style: TextStyle(fontSize: 20),)
                    ],),

               Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Row(children: [   
                      Expanded(
                            child: CustomeTextField(
                            controller:  keyword,
                            validator: Validator.notEmpty,
                            hintTxt: "enter_mobile_phone_or_name".tr(),
                            labelTxt: "mobile_phone_or_name".tr(),
                        ),
                      ),

                      SizedBox(width: 15,),

                      CustomeButton(title: "search".tr(),icon: null,handler: (){
                        if (_formKey.currentState.validate()) {
                        Navigator.pushNamed(context, '/customers',arguments: {
                          "keyword" : keyword.text,
                          "customerId" : null
                        });
                            }
                      },),
                      ],),
                    ),
                  ),

                  ListTile(
                    title: Text("اجمالي ارصدة العملاء : $totalBalance EGP "),
                  ),

                  customers.isEmpty && !isLoading ? ProductPlaceholder() : SizedBox(),
                  customers.isEmpty && !isLoading ? SizedBox() : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Pagination(
                            
                            progress: loadingKit,
                            pageBuilder: (currentListSize) => getProductsLocal(),
                            itemBuilder: (index, Customer customer) => ListItem(
                              id: customer.id.toString(),
                              addresses: customer.addresses,
                              name: customer.name.toString(),
                              phoneNumber: customer.phoneNumber.toString(),
                              balance: customer.balance,
                              
                              ),
                                ),
                          ),
                  ),


              ],),
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


class ListItem extends StatelessWidget {

  String id;
  String name;
  String phoneNumber;
  List<Addresses> addresses;
  String balance;

  ListItem({this.addresses,this.id,this.name,this.phoneNumber,this.balance});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


    Text(
          'كود العميل : #$id',
            style: TextStyle(
            fontFamily: 'Lato',

              fontSize: 18,
              color: const Color(0xff8F8D8D),
            ),
            textAlign: TextAlign.left,
          ),
                  

    Text(
    'الأسم : $name',
    style: TextStyle(
        fontSize: 18,
      color: const Color(0xff3a3a3a),
      fontWeight: FontWeight.w300,
    ),
    textAlign: TextAlign.left,
    ),

    Text(
    'رقم الموبايل : $phoneNumber',
    style: TextStyle(
        fontSize: 18,
      color: const Color(0xff3a3a3a),
      fontWeight: FontWeight.w300,
    ),
    textAlign: TextAlign.left,
    ),

    addresses.length != 0 ? Text(
    "العنوان : " + addresses[0].address,
    style: TextStyle(
        fontSize: 15,
      color: const Color(0xff3a3a3a),
      fontWeight: FontWeight.w300,
    ),
    textAlign: TextAlign.left,
    ) : SizedBox(),
    
    Divider(),

    Text("الرصيد الحالي للعميل : $balance جنيه"),


  SizedBox(height: 5,),


    Container(
      width: MediaQuery. of(context). size. width - 26,
      child: Row(
        children: [
        
          Expanded(child: CustomeButton(title: "اذونات السداد الخاص بالعميل".tr()
          ,icon: null
          ,handler: () {
            Navigator.pushNamed(context, '/transactions_reports',arguments: {
              "customerId" : id,
            });
          },)),

      ],),
    ),
  
      Container(
      width: MediaQuery. of(context). size. width - 26,
      child: Row(
        children: [
        
          Expanded(child: CustomeButton(title: "اذونات السداد من تاريخ الي تاريخ".tr()
          ,icon: null
          ,handler: () {
            Navigator.pushNamed(context, '/transactions_reports',arguments: {
              "customerId" : id,
            });
          })),

      ],),
    ),
  
      Container(
      width: MediaQuery. of(context). size. width - 26,
      child: Row(
        children: [
                      Expanded(child: CustomeButton(title: "addresses".tr()
                ,icon: null
                ,handler: () => Navigator.pushNamed(context, '/addresses',arguments: addresses),)),


                Expanded(child: CustomeButton(title: "فواتير العميل".tr(),
                mainColor: true,
                icon: null,handler: () => Navigator.pushNamed(context, '/orders',arguments: {
                          "keyword" : null,
                          "customerId" : id
                        }),)),

                ],),
    ),

    Container(
      width: MediaQuery. of(context). size. width - 26,
      child: Row(
        children: [
          
    
                                        Expanded(child: CustomeButton(title: "فواتير العميل من فترة الي فترة".tr(),
                mainColor: true,
                icon: null,handler: () => Navigator.pushNamed(context, '/orders',arguments: {
                          "keyword" : null,
                          "customerId" : id
                        }),)),
      ],),
    )

          ],)
        ],),
      Divider()
    ],);
  }
}



class ProductPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Expanded(
               child: Column(
               mainAxisSize: MainAxisSize.max,
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 FaIcon(FontAwesomeIcons.users,size: 75,color: const Color(0xffe6d7d7),),
                 SizedBox(height: 12,),
                  Center(
                    child: Text(
                     'no_users'.tr(),
                      style: TextStyle(
                        fontSize: 25,
                        color: const Color(0xffdbd3d3),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 12,),
             ],),
           ) ;
  }
}
