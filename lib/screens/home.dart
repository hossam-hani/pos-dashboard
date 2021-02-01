import 'package:eckit/components/bottomBar.dart';
import 'package:eckit/screens/customers/customersList.dart';
import 'package:eckit/screens/orders/ordersList.dart';
import 'package:eckit/screens/products/productList.dart';
import 'package:eckit/store_settings.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/customeButton.dart';
import 'categories/categoriesList.dart';
import 'overview.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Widget page = SizedBox();
  int currentIndex = 2;

  changeCurrentIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }
  changeCurrentPage(String newPage){
    if(newPage == "products"){

      setState(() {
        page = ProductList(changePageHandler: changeCurrentPage,);
      });
    }else if(newPage == "categories"){
      setState(() {
        page = CategoriesList(changePageHandler: changeCurrentPage,);
      });   
    }else if(newPage == "orders"){
      setState(() {
        page = OrderList(changePageHandler: changeCurrentPage,);
      });   
    }else if(newPage == "customers"){
      setState(() {
        page = CustomerList(changePageHandler: changeCurrentPage,);
      });
    }else if(newPage == "settings"){
      setState(() {
        page = StoreSettings(changePageHandler: changeCurrentPage,);
      });      
    }
    else if(newPage == "overview"){
      setState(() {
        page = OverView(changePageHandler: changeCurrentPage,);
      });      
    }
  }
  
  @override
  void initState() {
    super.initState();
    setState(() {
        page = OverView(changePageHandler: changeCurrentPage,);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomBar(changePageHandler: changeCurrentPage, changeCurrentIndex : changeCurrentIndex),
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Image.asset("assets/images/logo.png" , height: 70,)
        ),
        body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: currentIndex == 2 ? OverView(changePageHandler: changeCurrentPage,)
           : currentIndex == 0 ? ProductList(changePageHandler: changeCurrentPage, changeCurrentIndex : changeCurrentIndex) :
           currentIndex == 1 ? CustomerList(changePageHandler: changeCurrentPage,) : 
           currentIndex == 3 ? OrderList(changePageHandler: changeCurrentPage,) :
           currentIndex == 4 ? StoreSettings(changePageHandler: changeCurrentPage,) :
           currentIndex == 5 ? CategoriesList(changePageHandler: changeCurrentPage, changeCurrentIndex : changeCurrentIndex) 
           : SizedBox()
        ),
      ),
      );
  }
}
