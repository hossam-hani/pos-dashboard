import 'package:cached_network_image/cached_network_image.dart';
import 'package:eckit/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/items.dart';
import 'package:easy_localization/easy_localization.dart';

class AddressesList extends StatelessWidget {

  List<Addresses> addresses;


  AddressesList({this.addresses});


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
          title: Image.asset("assets/images/logo.png" , height: 70,)
        ),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child:   Text(
              'addresses'.tr(),
              style: TextStyle(  
                fontSize: 20,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,  
            ),
          ),

            ... addresses.map((address) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
      Text(
      address.address,
      style: TextStyle(
          fontSize: 15,
        color: const Color(0xff3a3a3a),
        fontWeight: FontWeight.w300,
      ),
      textAlign: TextAlign.left,
    ),
                  Divider()

              ],),
            )).toList()
           
        ],),
    );
  }
}




class ListItem extends StatelessWidget {
  String title;
  String id;
  String price;
  String category;
  String currency;
  String image;
  String quantity;
  String notes;
  String unit;


  ListItem({this.title,this.id,this.price,this.category,this.currency,this.image,this.quantity,this.notes,this.unit});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [

        image == null ? FaIcon(FontAwesomeIcons.box,size: 55,color: const Color(0xffe6d7d7),) :CachedNetworkImage(
            height: 100,
            width: 100,
            imageUrl: image,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
        ),

     SizedBox(width: 25,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
     Text(
      '#$id',
        style: TextStyle(
          fontSize: 15,
          color: const Color(0xffe6d7d7),
        ),
        textAlign: TextAlign.left,
      ),
      Text(
      '$title',
      style: TextStyle(
          fontSize: 15,
        color: const Color(0xff3a3a3a),
        fontWeight: FontWeight.w300,
      ),
      textAlign: TextAlign.left,
    ),
    Text(
    '$price $currency',
    style: TextStyle(
      fontFamily: 'Lato',
      fontSize: 15,
      color: const Color(0xff3a3a3a),
      fontWeight: FontWeight.w300,
    ),
    textAlign: TextAlign.left,
  ),
  Text(
    '$category',
    style: TextStyle(
      fontSize: 10,
      color: const Color(0xff8F8D8D),
      fontWeight: FontWeight.w300,
    ),
    textAlign: TextAlign.left,
  ),

    Text(
    "quantity".tr() +' : $quantity $unit',
    style: TextStyle(
      fontSize: 20,
      fontFamily: "Lato",
      color: Colors.black,
      fontWeight: FontWeight.w300,
    ),
    textAlign: TextAlign.left,
  ),

  
  notes == null ? SizedBox() : Text(
    '$notes',
    style: TextStyle(
      fontSize: 20,
      color: const Color(0xff8F8D8D),
      fontWeight: FontWeight.w300,
    ),
    textAlign: TextAlign.left,
  ),


          ],)
        ],),
      Divider()
    ],);
  }
}