import 'package:eckit/models/category.dart';
import 'package:eckit/models/store.dart';
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

class StoresList extends StatefulWidget {

  dynamic changePageHandler;
  dynamic changeCurrentIndex;

  StoresList({this.changePageHandler,this.changeCurrentIndex});

  @override
  _StoresListState createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {

   List<Store> stores = [];
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

  Future<List<Store>> getStoresLocal() async {

    List<Store> temp = await StoreServices.getStores(currentPage.toString());
    setState(() {
      stores = stores.isEmpty ? temp : stores;
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
                  FaIcon(FontAwesomeIcons.mapMarked),
                  SizedBox(width: 10,),
                  Text("stores".tr(),style: TextStyle(fontSize: 20),)
                ],),
                SizedBox(height: 15,),

                Row(children: [   
                  Expanded(child: CustomeButton(title: "add_store",icon: FontAwesomeIcons.plus,handler: () => Navigator.pushNamed(context, '/store_editor'),)),
                ],),


                Row(children: [   
                  Expanded(child: CustomeButton(title: "إنشاء حركة مخزون",icon: FontAwesomeIcons.plus,handler: () => Navigator.pushNamed(context, '/inventory_transactions_editor'),)),
                  Expanded(child: CustomeButton(title: "حركة المخزون",icon: FontAwesomeIcons.truckLoading,handler: () => Navigator.pushNamed(context, '/inventory_transactions'),)),
                ],),

                stores.isEmpty && !isLoading ? CategoryPlaceholder() : SizedBox(),
                stores.isEmpty && !isLoading ? SizedBox() : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Pagination(
                          progress: loadingKit,
                          pageBuilder: (currentListSize) => getStoresLocal(),
                          itemBuilder: (index, Store store) => ListItem(
                            title: store.name.toString(),
                            id: store.id.toString(),
                            store: store,),
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
  String image;
  Store store;


  ListItem({this.title,this.id,this.image,this.store});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.pushNamed(context, '/store_editor',arguments: store),
        child: Column(
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
        '$title',
          style: TextStyle(
              fontSize: 15,
            color: const Color(0xff3a3a3a),
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.left,
        ),

 


            ],)
          ],),

          SizedBox(height: 20,),   

            Container(
              width: MediaQuery. of(context). size. width - 26,
              child: Row(
                children: [
                
                  Expanded(child: CustomeButton(title: "محتويات المخزن".tr()
                  ,icon: null
                  ,handler: () {
                    Navigator.pushNamed(context, '/inventory_content',arguments: id);
                  },)),

              ],),
            ),

        Divider()
      ],),
    );
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
