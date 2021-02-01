import 'package:dio/dio.dart';
import 'package:eckit/models/boot_data.dart';
import 'package:eckit/services/boot_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const.dart';
import 'package:easy_localization/easy_localization.dart';

class SelectCategory extends StatefulWidget {
  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {

  String currentCategory;
  BootData bootdata;
  bool isLoading = false;


  
  next(){
    if(currentCategory == null){
       showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("alert").tr(),
              content: new Text("alert_about_select_category").tr(),
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
       Navigator.pushNamed(context, '/shop_details',arguments: bootdata);
    }
  }

  changeCurrentCagtegory(String newCategory) async{
    
    setState(() {
      currentCategory = newCategory;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('category', newCategory);
  }

  getBootData() async {
     BootData temp = await Boot_Service.get_bootData();
     setState(() {
       bootdata = temp;
       isLoading = false;
     });
     
  }

  initCategoryValue() async{
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String category = prefs.getString("category");

    setState(() {
      currentCategory = category;
    });
  }
  

  @override 
  void initState() {
    super.initState();
    initCategoryValue();
    getBootData();
  }

  @override
  Widget build(BuildContext context) {

    var loadingKit = Center(
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
          body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
          child: isLoading  ? loadingKit : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ... bootdata.categories.map((category) => CategoryItem(
            categoryTitle: category.title,
            categoryDescription: category.description,
            imageUrl: category.imageUrl,
            currentCategory: currentCategory,
            changeCategoryHandler: changeCurrentCagtegory,
            keyData: category.key,))
          ,
        ],),
      ),
    ),);
  }
}

class CategoryItem extends StatelessWidget {
  String currentCategory;
  dynamic changeCategoryHandler;
  String categoryTitle;
  String categoryDescription;
  String imageUrl;
  String keyData;

  CategoryItem({this.currentCategory,this.changeCategoryHandler
  ,this.categoryTitle,this.imageUrl,this.categoryDescription,this.keyData});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
        Row(children: [
          InkWell(
            child: CustomeCheckBox(isActive: keyData == currentCategory,),
            onTap: () => changeCategoryHandler(keyData),
            ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.network(imageUrl,width: 50,),
          ),
          Expanded (
                child: new Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                        Text(
                            categoryTitle,
                            style: TextStyle(
                              fontSize: 20,
                              color: const Color(0xff1d1c1c),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        Text(categoryDescription,
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xff7a7171),
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    ],
                ),
              )
        ],),
        Divider()
    ],);
  }
}

class CustomeCheckBox extends StatelessWidget {
  bool isActive;

  CustomeCheckBox({this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
    width: 30.0,
    height: 30.0,
    decoration: BoxDecoration(
      color: isActive ? mainColor : Colors.white,
      border: Border.all(width: 1.0, color: const Color(0xffe5e2e2)),
    ),
  );
  }
}