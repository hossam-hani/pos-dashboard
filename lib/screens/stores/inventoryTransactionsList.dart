import 'package:eckit/models/category.dart';
import 'package:eckit/models/inventory_transaction.dart';
import 'package:eckit/models/store.dart';
import 'package:eckit/services/inventory_services.dart';
import 'package:eckit/services/stores_service.dart';
import '../../services/regions_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../components/customeButton.dart';
import 'package:paging/paging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../const.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../models/region.dart';

class InventoryTransactionsList extends StatefulWidget {

  InventoryTransactionsList();

  @override
  _InventoryTransactionsListListState createState() => _InventoryTransactionsListListState();
}

class _InventoryTransactionsListListState extends State<InventoryTransactionsList> {

  List<InventoryTransaction>  inventorytransactions = [];
  int currentPage = 1;
  bool isLoading = false;
  
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

  Future<List<InventoryTransaction>> getStoresLocal() async {

    List<InventoryTransaction> temp = await InventoryServices.getInventroyTreanscations(currentPage.toString());
    
    setState(() {
      inventorytransactions = inventorytransactions.isEmpty ? temp : inventorytransactions;
      currentPage = currentPage+1;
      isLoading = false;
    });

    return temp;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading =  true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Center(child: FaIcon(FontAwesomeIcons.times,color:Colors.black),),
            ),
          title: Image.asset("assets/images/logo.png" , height: 40,)
        ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                Row(children: [
                  FaIcon(FontAwesomeIcons.truckLoading),
                  SizedBox(width: 10,),
                  Text("حركة المخزون".tr(),style: TextStyle(fontSize: 20),)
                ],),

                SizedBox(height: 15,),


                inventorytransactions.isEmpty && !isLoading ? CategoryPlaceholder() : SizedBox(),
                inventorytransactions.isEmpty && !isLoading ? SizedBox() : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Pagination(
                          progress: loadingKit,
                          pageBuilder: (currentListSize) => getStoresLocal(),
                          itemBuilder: (index, InventoryTransaction inventorytransaction) => ListItem(
                            type: inventorytransaction.type,
                            fromInventory: inventorytransaction.fromInventroy.name,
                            toInventory: inventorytransaction.toInventroy == null ? null : inventorytransaction.toInventroy.name ,
                            id: inventorytransaction.id.toString(),
                            status : inventorytransaction.status.toString(),
                            productName: inventorytransaction.product.name,
                            quantity : inventorytransaction.quantity.toString()
                            ),
                              ),
                        ),
                ),


              ],),
          ),
    );
  }
}


class ListItem extends StatelessWidget {
  String title;
  String id;
  String fromInventory;
  String toInventory;
  String productName;
  String type;
  String status;
  String quantity;


  ListItem({this.title,this.id,this.fromInventory,this.productName,this.toInventory,this.type,this.status,this.quantity});
  @override
  Widget build(BuildContext context) {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [

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
      'نوع الحركة : ' + (type == "sales" ? "مبيعات" : type == "purchases" ? "مشتريات"  : type == "transfer" ? "نقل"  : "هوالك"),
      style: TextStyle(
          fontSize: 16,
        color: const Color(0xff3a3a3a),
        fontWeight: FontWeight.w300,
      ),
      textAlign: TextAlign.left,
    ),

    Text(
    'حالة الحركة : ' + (status == "approved" ? "تمت الموافقة عليها" : status == "refused" ? "مرفوضة" : "بإنتظار الموافقة ( معلقة )"),
      style: TextStyle(
          fontSize: 16,
        color: const Color(0xff3a3a3a),
        fontWeight: FontWeight.w300,
      ),
      textAlign: TextAlign.left,
    ),
    
    Text(
    'المنتج : $productName',
      style: TextStyle(
          fontSize: 16,
        color: const Color(0xff3a3a3a),
        fontWeight: FontWeight.w300,
      ),
      textAlign: TextAlign.left,
    ),

    Text(
    'الكمية : $quantity',
      style: TextStyle(
          fontSize: 16,
        color: const Color(0xff3a3a3a),
        fontWeight: FontWeight.w300,
      ),
      textAlign: TextAlign.left,
    ),

    Text(
    'من المخزن : $fromInventory',
      style: TextStyle(
          fontSize: 16,
        color: const Color(0xff3a3a3a),
        fontWeight: FontWeight.w300,
      ),
      textAlign: TextAlign.left,
    ),

   toInventory == null ? SizedBox() : Text(
    'الي المخزن : $toInventory',
      style: TextStyle(
          fontSize: 16,
        color: const Color(0xff3a3a3a),
        fontWeight: FontWeight.w300,
      ),
      textAlign: TextAlign.left,
    ),


        ],)
      ],),

      SizedBox(height: 20,),   

     status != "waiting" ? SizedBox() :  Container(
          width: MediaQuery. of(context). size. width - 26,
          child: Row(
            children: [
            
              Expanded(child: CustomeButton(title: "تأكيد الحركة".tr()
              ,icon: FontAwesomeIcons.check,
              handler: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            new CircularProgressIndicator(),
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text("جاري التحميل"),
                             ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                
                await InventoryServices.acceptInventoryTranscation(id);
                Navigator.pop(context);
                Navigator.popAndPushNamed(context, '/inventory_transactions');
                
              },)),

          ],),
        ),

      Divider(color: Colors.black,)
      ],);
  }
}



class CategoryPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Expanded(
               child: Column(
               mainAxisSize: MainAxisSize.max,
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 FaIcon(FontAwesomeIcons.mapMarked,size: 75,color: const Color(0xffe6d7d7),),
                 SizedBox(height: 12,),
                  Center(
                    child: Text(
                     'start_add_your_regions'.tr(),
                      style: TextStyle(
                        fontSize: 25,
                        color: const Color(0xffdbd3d3),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 12,),
                SizedBox(
                width: 200,
                child: CustomeButton(title: "add_region",
                icon: FontAwesomeIcons.plus,handler: () => Navigator.pushNamed(context, '/region_editor'),)),

             ],),
           ) ;
  }
}
