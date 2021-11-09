import 'package:eckit/utilities/utilities.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:eckit/components/bottomBar.dart';
import 'package:eckit/screens/customers/customersList.dart';
import 'package:eckit/screens/orders/ordersList.dart';
import 'package:eckit/screens/products/productList.dart';
import 'package:eckit/services/account_service.dart';
import 'package:eckit/store_settings.dart';
import 'package:provider/provider.dart';

import '../components/drawerContent.dart';
import 'categories/categoriesList.dart';
import 'overview.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget page = SizedBox();
  int currentIndex = 2;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _homeScreenText = "text";

  changeCurrentIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  changeCurrentPage(String newPage) {
    if (newPage == "products") {
      setState(() {
        page = ProductList(
          changePageHandler: changeCurrentPage,
        );
      });
    } else if (newPage == "categories") {
      setState(() {
        page = CategoriesList(
          changePageHandler: changeCurrentPage,
        );
      });
    } else if (newPage == "orders") {
      setState(() {
        page = OrderList(
          changePageHandler: changeCurrentPage,
        );
      });
    } else if (newPage == "customers") {
      setState(() {
        page = CustomerList(
          changePageHandler: changeCurrentPage,
        );
      });
    } else if (newPage == "settings") {
      setState(() {
        page = StoreSettings(
          changePageHandler: changeCurrentPage,
        );
      });
    } else if (newPage == "overview") {
      setState(() {
        page = OverView(
          changePageHandler: changeCurrentPage,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      _initMessaging();
    }

    setState(() {
      page = OverView(
        changePageHandler: changeCurrentPage,
      );
    });
  }

  Future<void> _initMessaging() async {
    _firebaseMessaging.configure(
      onMessage: _handleNotificationMessages,
      onLaunch: _handleNotificationMessages,
      onResume: _handleNotificationMessages,
    );
    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(provisional: true));
    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      await AccountService.addTokenToUser(token: token);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
  }

  void _handleNotificationMessages(Map<String, dynamic> message) {
    final _message = message["notification"]["body"];
    Fluttertoast.showToast(
      msg: _message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 30.0,
    );
    print("onResume: $message");
    NotificationHandler.get(context).addNewNotificationMessage();
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _drawerKey, // assign key to Scaffold
      drawer: Drawer(
        child: DrawerContent(),
      ),
      bottomNavigationBar: BottomBar(
        changePageHandler: changeCurrentPage,
        changeCurrentIndex: changeCurrentIndex,
      ),

      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [
            Consumer<NotificationHandler>(
              builder: (context, provider, child) {
                final notificationCount = provider.currentNotificationCount;

                return Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(context, '/notifications'),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.solidBell,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (notificationCount != null)
                      PositionedDirectional(
                        start: 11,
                        top: 30,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              notificationCount > 10 ? '+10' : '$notificationCount',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial',
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            )
          ],
          leading: InkWell(
            onTap: () => _drawerKey.currentState.openDrawer(),
            child: Center(
              child: FaIcon(FontAwesomeIcons.bars, color: Colors.black),
            ),
          ),
          title: Image.asset(
            "assets/images/logo.png",
            height: 40,
          )),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: currentIndex == 2
                ? OverView(
                    changePageHandler: changeCurrentPage,
                  )
                : currentIndex == 0
                    ? ProductList(changePageHandler: changeCurrentPage, changeCurrentIndex: changeCurrentIndex)
                    : currentIndex == 1
                        ? CustomerList(
                            changePageHandler: changeCurrentPage,
                          )
                        : currentIndex == 3
                            ? OrderList(
                                changePageHandler: changeCurrentPage,
                              )
                            : currentIndex == 4
                                ? StoreSettings(
                                    changePageHandler: changeCurrentPage,
                                  )
                                : currentIndex == 5
                                    ? CategoriesList(
                                        changePageHandler: changeCurrentPage, changeCurrentIndex: changeCurrentIndex)
                                    : SizedBox()),
      ),
    );
  }
}
