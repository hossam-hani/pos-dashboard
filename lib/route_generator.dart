
import 'package:eckit/screens/create_account.dart';
import 'package:eckit/screens/home.dart';
import 'package:eckit/screens/intro.dart';
import 'package:eckit/screens/products/productEditor.dart';
import 'package:flutter/material.dart';
import 'screens/account_details.dart';
import 'screens/categories/categoryEditor.dart';
import 'screens/customers/addressesList.dart';
import 'screens/customers/customersList.dart';
import 'screens/edit_shop_detials.dart';
import 'screens/login.dart';
import 'screens/orders/changeStatus.dart';
import 'screens/orders/orderItems.dart';
import 'screens/orders/ordersList.dart';
import 'screens/selectCategory.dart';
import 'screens/shop_details.dart';
import 'screens/splash.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch (settings.name){
      case '/' :
        return MaterialPageRoute(builder: (_) => Intro());    
      case '/splash' :
        return MaterialPageRoute(builder: (_) => Splash());    
      case '/select_category' :
        return MaterialPageRoute(builder: (_) => SelectCategory());       
      case '/account_details' :
        return MaterialPageRoute(builder: (_) => AccountDetails(bootData: args,));    
      case '/create_account' :
        return MaterialPageRoute(builder: (_) => CreateAccount());     
      case '/home' :
        return MaterialPageRoute(builder: (_) => Home());   
      case '/orders' :
        return MaterialPageRoute(builder: (_) => OrderList(keyword: (args as Map)["keyword"],customerID: (args as Map)["customerId"],));     
      case '/orders_items' :
        return MaterialPageRoute(builder: (_) => OrderItems(items: args,));    
      case '/change_status' :
        return MaterialPageRoute(builder: (_) => ChangeOrderDetails(orderId: (args as Map)["orderId"],currentStatus: (args as Map)["currentStatus"],));    
      case '/customers' :
        return MaterialPageRoute(builder: (_) => CustomerList(keyword: (args as Map)["keyword"],customerID: (args as Map)["customerId"],));    
      case '/addresses' :
        return MaterialPageRoute(builder: (_) => AddressesList(addresses: args,));               
      case '/shop_details' :
        return MaterialPageRoute(builder: (_) => ShopDetails(bootData: args,));     
      case '/category_editor' :
        return MaterialPageRoute(builder: (_) => CategoryEditor(category: args,));  
      case '/product_editor' :
        return MaterialPageRoute(builder: (_) => ProductEditor(product: args,));    
      case '/login' :
        return MaterialPageRoute(builder: (_) => Login());    
      case '/edit_shop_details' :
        return MaterialPageRoute(builder: (_) => ShopDetials());    

          
    }
  
    return null;

  }
}