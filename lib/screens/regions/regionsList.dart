import 'package:eckit/models/category.dart';
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

class RegionsList extends StatefulWidget {

  dynamic changePageHandler;
  dynamic changeCurrentIndex;

  RegionsList({this.changePageHandler,this.changeCurrentIndex});

  @override
  _RegionsListState createState() => _RegionsListState();
}

class _RegionsListState extends State<RegionsList> {

   List<Region> regions = [];
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

  Future<List<Region>> getRegionsLocal() async {

    List<Region> temp = await RegionsServices.getRegions(currentPage.toString());
    setState(() {
      regions = regions.isEmpty ? temp : regions;
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
          title: Image.asset("assets/images/logo.png" , height: 70,)
        ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(children: [
                  FaIcon(FontAwesomeIcons.mapMarked),
                  SizedBox(width: 10,),
                  Text("regions".tr(),style: TextStyle(fontSize: 20),)
                ],),
                SizedBox(height: 15,),

                Row(children: [   
                CustomeButton(title: "add_region",icon: FontAwesomeIcons.plus,handler: () => Navigator.pushNamed(context, '/region_editor'),),
                ],),

                regions.isEmpty && !isLoading ? CategoryPlaceholder() : SizedBox(),
                regions.isEmpty && !isLoading ? SizedBox() : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Pagination(
                          progress: loadingKit,
                          pageBuilder: (currentListSize) => getRegionsLocal(),
                          itemBuilder: (index, Region region) => ListItem(
                            title: region.name.toString(),
                            id: region.id.toString(),
                            region: region,),
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
  Region region;


  ListItem({this.title,this.id,this.image,this.region});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.pushNamed(context, '/region_editor',arguments: region),
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
