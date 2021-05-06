import 'package:cached_network_image/cached_network_image.dart';
import 'package:eckit/services/orders_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../const.dart';
import '../../models/items.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangeOrderDetails extends StatefulWidget {
  String orderId;
  String currentStatus;

  ChangeOrderDetails({this.orderId,this.currentStatus});

  @override
  _ChangeOrderDetailsState createState() => _ChangeOrderDetailsState();
}

class _ChangeOrderDetailsState extends State<ChangeOrderDetails> {

  String status;
  bool isLoading = false;
  
  changeStatus(String newStatus) async{
    setState(() {
      isLoading = true;
    });

    print(widget.orderId);
    
    await OrderServices.updateSatus(newStatus: newStatus,orderId : widget.orderId);

    setState(() {
      status = newStatus;
      isLoading = false;
    });
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      status = widget.currentStatus;
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child:   Text(
              'change_status'.tr(),
              style: TextStyle(  
                fontSize: 20,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,  
            ),
          ),

          isLoading ? loadingKit : Padding(
            padding: const EdgeInsets.all(8.0),
            child: new DropdownButton<String>(
              value: status,
              isExpanded: true,
              items: statusList.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value.tr()),
                );
              }).toList(),
              onChanged: (newValue) => changeStatus(newValue),
            ),
          ),

            
           
        ],),
    );
  }
}