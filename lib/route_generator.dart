import 'package:flutter/material.dart';

import 'package:eckit/screens/create_account.dart';
import 'package:eckit/screens/home.dart';
import 'package:eckit/screens/intro.dart';
import 'package:eckit/screens/notificationsList.dart';
import 'package:eckit/screens/products/productEditor.dart';
import 'package:eckit/screens/products/productList.dart';
import 'package:eckit/screens/stock/stockEditor.dart';
import 'package:eckit/screens/suppliers/suppliersList.dart';
import 'package:eckit/screens/transactions/transactionsList.dart';
import 'package:eckit/screens/users/usersEditor.dart';
import 'package:eckit/screens/users/usersList.dart';

import './screens/points/pointsEditor.dart';
import './screens/regions/regionsEditor.dart';
import './screens/regions/regionsList.dart';
import 'screens/account_details.dart';
import 'screens/categories/categoryEditor.dart';
import 'screens/costs/CostEditor.dart';
import 'screens/costs/costsReport.dart';
import 'screens/customers/addressesList.dart';
import 'screens/customers/customersList.dart';
import 'screens/customers/customersReport.dart';
import 'screens/edit_shop_detials.dart';
import 'screens/login.dart';
import 'screens/orders/changeStatus.dart';
import 'screens/orders/orderItems.dart';
import 'screens/orders/ordersList.dart';
import 'screens/orders/ordersReport.dart';
import 'screens/selectCategory.dart';
import 'screens/shop_details.dart';
import 'screens/splash.dart';
import 'screens/stock/stocksList.dart';
import 'screens/stores/inventoryContent.dart';
import 'screens/stores/inventoryTransactionEditor.dart';
import 'screens/stores/inventoryTransactionsList.dart';
import 'screens/stores/storesEditor.dart';
import 'screens/stores/storesList.dart';
import 'screens/suppliers/supplierEditor.dart';
import 'screens/suppliers/supplierInvoiceEditor.dart';
import 'screens/suppliers/suppliersInvoicesReport.dart';
import 'screens/taxesEditor.dart';
import 'screens/transactions/TransactionEditor.dart';
import 'screens/transactions/transactionsReport.dart';
import 'screens/visits/vstistsReport.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Intro());
      case '/splash':
        return MaterialPageRoute(builder: (_) => Splash());
      case '/select_category':
        return MaterialPageRoute(builder: (_) => SelectCategory());
      case '/customers_reports':
        return MaterialPageRoute(builder: (_) => CustomersReport());
      case '/transactions_reports':
        return MaterialPageRoute(
            builder: (_) => TransactionsReport(
                  customerId: (args as Map)["customerId"],
                  startAt: (args as Map)["startAt"],
                  endAt: (args as Map)["endAt"],
                ));
      case '/inventory_content':
        return MaterialPageRoute(
          builder: (_) => InventoryContent(
            inventoryId: args,
          ),
        );
      case '/inventory_transactions':
        return MaterialPageRoute(
          builder: (_) => InventoryTransactionsList(),
        );
      case '/inventory_transactions_editor':
        return MaterialPageRoute(
          builder: (_) => InventoryTransactionEditor(),
        );
      case '/supplier_invoice_editor':
        return MaterialPageRoute(
          builder: (_) => SupplierInvoiceEditor(),
        );
      case '/suppliers_invoices':
        return MaterialPageRoute(
            builder: (_) => SuppliersInvoicesReport(
                supplierId: (args as Map)["supplierId"],
                startAt: (args as Map)["startAt"],
                endAt: (args as Map)["endAt"]));
      // case '/inventory_transactions_editor' :
      //   return MaterialPageRoute(builder: (_) => InventoryTransactionEditor());
      case '/cost_editor':
        return MaterialPageRoute(builder: (_) => CostEditor());
      case '/taxes_editor':
        return MaterialPageRoute(builder: (_) => TaxesEditor());
      case '/orders_reports':
        return MaterialPageRoute(
            builder: (_) => OrdersReport(
                customerId: (args as Map)["customerId"],
                startAt: (args as Map)["startAt"],
                endAt: (args as Map)["endAt"]));
      case '/vstists_reports':
        return MaterialPageRoute(
            builder: (_) => VstistsReport(
                customerId: (args as Map)["customerId"],
                startAt: (args as Map)["startAt"],
                endAt: (args as Map)["endAt"]));
      case '/costs_reports':
        return MaterialPageRoute(
            builder: (_) => CostsReport(
                  type: (args as Map)["type"],
                  startAt: (args as Map)["startAt"],
                  endAt: (args as Map)["endAt"],
                ));
      case '/account_details':
        return MaterialPageRoute(
            builder: (_) => AccountDetails(
                  bootData: args,
                ));
      case '/create_account':
        return MaterialPageRoute(builder: (_) => CreateAccount());
      case '/home':
        return MaterialPageRoute(builder: (_) => Home());
      case '/orders':
        return MaterialPageRoute(
            builder: (_) => OrderList(
                  keyword: (args as Map)["keyword"],
                  customerID: (args as Map)["customerId"],
                ));
      case '/products':
        return MaterialPageRoute(
            builder: (_) => ProductList(
                  categoryId: args,
                ));
      case '/orders_items':
        return MaterialPageRoute(
            builder: (_) => OrderItems(
                  items: args,
                ));
      case '/change_status':
        return MaterialPageRoute(
            builder: (_) => ChangeOrderDetails(
                  orderDetailsArgs: args,
                ));
      case '/customers':
        return MaterialPageRoute(
            builder: (_) => CustomerList(
                  keyword: (args as Map)["keyword"],
                  customerID: (args as Map)["customerId"],
                ));
      case '/addresses':
        return MaterialPageRoute(
            builder: (_) => AddressesList(
                  addresses: args,
                ));
      case '/shop_details':
        return MaterialPageRoute(
            builder: (_) => ShopDetails(
                  bootData: args,
                ));
      case '/category_editor':
        return MaterialPageRoute(
            builder: (_) => CategoryEditor(
                  categoryArgs: args,
                ));
      case '/product_editor':
        return MaterialPageRoute(
            builder: (_) => ProductEditor(
                  productArgs: args,
                ));
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/points_editor':
        return MaterialPageRoute(builder: (_) => PointsEditor());
      case '/edit_shop_details':
        return MaterialPageRoute(builder: (_) => ShopDetials());
      case '/regions':
        return MaterialPageRoute(builder: (_) => RegionsList());
      case '/region_editor':
        return MaterialPageRoute(
            builder: (_) => RegionEditor(
                  regionArgs: args,
                ));
      case '/stores':
        return MaterialPageRoute(builder: (_) => StoresList());
      case '/store_editor':
        return MaterialPageRoute(
            builder: (_) => StoreEditor(
                  storeArgs: args,
                ));
      case '/suppliers':
        return MaterialPageRoute(builder: (_) => SuppliersList());
      case '/supplier_editor':
        return MaterialPageRoute(
            builder: (_) => SuppliersEditor(
                  supplierArgs: args,
                ));
      case '/stocks':
        return MaterialPageRoute(builder: (_) => StocksList());
      case '/stocks_editor':
        return MaterialPageRoute(
            builder: (_) => StockEditor(
                  stockArgs: args,
                ));
      case '/transactions':
        return MaterialPageRoute(
            builder: (_) => TransactionsList(
                  startAt: args == null
                      ? null
                      : !(args as Map).containsKey("startAt")
                          ? null
                          : (args as Map)["startAt"],
                  endAt: args == null
                      ? null
                      : !(args as Map).containsKey("endAt")
                          ? null
                          : (args as Map)["endAt"],
                  recipientId: args == null
                      ? null
                      : !(args as Map).containsKey("recipientId")
                          ? null
                          : (args as Map)["recipientId"],
                  recipientType: args == null
                      ? null
                      : !(args as Map).containsKey("recipientType")
                          ? null
                          : (args as Map)["recipientType"],
                ));
      case '/transactions_editor':
        return MaterialPageRoute(
            builder: (_) => TranscationEditor(
                  transactionArgs: args,
                ));
      case '/users':
        return MaterialPageRoute(builder: (_) => UsersList());
      case '/users_editor':
        return MaterialPageRoute(
            builder: (_) => UsersEditor(
                  userArgs: args,
                ));
      case '/notifications':
        return MaterialPageRoute(
          builder: (_) => NotificationsList(),
        );
    }

    return null;
  }
}
