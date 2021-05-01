
import 'package:eckit/screens/create_account.dart';
import 'package:eckit/screens/home.dart';
import 'package:eckit/screens/intro.dart';
import 'package:eckit/screens/products/productEditor.dart';
import 'package:eckit/screens/products/productList.dart';
import 'package:eckit/screens/stock/stockEditor.dart';
import 'package:eckit/screens/suppliers/suppliersList.dart';
import 'package:eckit/screens/transactions/transactionsList.dart';
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
import './screens/regions/regionsList.dart';
import './screens/regions/regionsEditor.dart';
import './screens/points/pointsEditor.dart';
import 'screens/stock/stocksList.dart';
import 'screens/stores/storesEditor.dart';
import 'screens/stores/storesList.dart';
import 'screens/suppliers/supplierEditor.dart';
import 'screens/transactions/TransactionEditor.dart';

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
      case '/products' :
        return MaterialPageRoute(builder: (_) => ProductList(categoryId: args,));   
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
      case '/points_editor' :
        return MaterialPageRoute(builder: (_) => PointsEditor());  
      case '/edit_shop_details' :
        return MaterialPageRoute(builder: (_) => ShopDetials());    
      case '/regions' :
        return MaterialPageRoute(builder: (_) => RegionsList());    
      case '/region_editor' :
        return MaterialPageRoute(builder: (_) => RegionEditor(region: args,));     
      case '/stores' :
        return MaterialPageRoute(builder: (_) => StoresList());   
      case '/store_editor' :
        return MaterialPageRoute(builder: (_) => StoreEditor(store: args,)); 
      case '/suppliers' :
        return MaterialPageRoute(builder: (_) => SuppliersList());  
      case '/supplier_editor' :
        return MaterialPageRoute(builder: (_) => SuppliersEditor(supplier: args,)); 
      case '/stocks' :
        return MaterialPageRoute(builder: (_) => StocksList()); 
      case '/stocks_editor' :
        return MaterialPageRoute(builder: (_) => StockEditor(stock: args,)); 
      case '/transactions' :
        return MaterialPageRoute(builder: (_) => TransactionsList(
        startAt: args == null? null : !(args as Map).containsKey("startAt") ? null : (args as Map)["startAt"],
        endAt:  args == null? null : !(args as Map).containsKey("endAt") ? null : (args as Map)["endAt"],
        recipientId :  args == null? null : !(args as Map).containsKey("recipientId") ? null : (args as Map)["recipientId"],
        recipientType:  args == null? null : !(args as Map).containsKey("recipientType") ? null : (args as Map)["recipientType"],));    
     case '/transactions_editor' :
        return MaterialPageRoute(builder: (_) => TranscationEditor(transaction: args,)); 

              
    }
    
  
    return null;

  }
}