import 'package:eckit/models/category.dart';
import 'package:eckit/services/categories_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../components/customeButton.dart';
import 'package:paging/paging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:eckit/services/product_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product.dart';
import '../../const.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoriesList extends StatefulWidget {

  dynamic changePageHandler;
  dynamic changeCurrentIndex;

  CategoriesList({this.changePageHandler,this.changeCurrentIndex});

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {

   List<Category> categories = [];
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

  Future<List<Category>> getCategoriesLocal() async {

    List<Category> temp = await CategoryServices.getCategories(currentPage.toString());
    setState(() {
      categories = categories.isEmpty ? temp : categories;
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
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            Row(children: [
              FaIcon(FontAwesomeIcons.boxes),
              SizedBox(width: 10,),
              Text("categories".tr(),style: TextStyle(fontSize: 20),)
            ],),
            SizedBox(height: 15,),

            Row(children: [   
            CustomeButton(title: "add_category",icon: FontAwesomeIcons.plus,handler: () => Navigator.pushNamed(context, '/category_editor'),),
            CustomeButton(title: "products",icon: FontAwesomeIcons.tags,handler: () => widget.changeCurrentIndex(0),),
            ],),

            categories.isEmpty && !isLoading ? CategoryPlaceholder() : SizedBox(),
            categories.isEmpty && !isLoading ? SizedBox() : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Pagination(
                      progress: loadingKit,
                      pageBuilder: (currentListSize) => getCategoriesLocal(),
                      itemBuilder: (index, Category category) => ListItem(
                        title: category.name.toString(),
                        id: category.id.toString(),
                        category: category,
                        image: category.image != null ? category.image : null,),
                          ),
                    ),
            ),


          ],);
  }
}


class ListItem extends StatelessWidget {
  String title;
  String id;
  String image;
  Category category;


  ListItem({this.title,this.id,this.image,this.category});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.pushNamed(context, '/category_editor',arguments: category),
        child: Column(
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
                 FaIcon(FontAwesomeIcons.box,size: 75,color: const Color(0xffe6d7d7),),
                 SizedBox(height: 12,),
                  Center(
                    child: Text(
                     'start_add_your_categories'.tr(),
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
                child: CustomeButton(title: "add_category",
                icon: FontAwesomeIcons.plus,handler: () => Navigator.pushNamed(context, '/category_editor'),)),

             ],),
           ) ;
  }
}
