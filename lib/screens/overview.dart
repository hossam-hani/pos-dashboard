import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paging/paging.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import 'package:eckit/models/account.dart';
import 'package:eckit/models/items.dart';
import 'package:eckit/models/order.dart';
import 'package:eckit/services/orders_service.dart';
import 'package:eckit/services/shop_service.dart';

import '../components/customeButton.dart';
import '../const.dart';
import 'orders/changeStatus.dart';

class OverView extends StatefulWidget {
  String keyword;
  String customerID;
  dynamic changePageHandler;

  OverView({this.changePageHandler, this.keyword, this.customerID});

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OverView> {
  List<Order> orders = [];
  int currentPage = 1;
  bool isLoading = false;
  final keyword = TextEditingController();
  String link;
  bool isPaid;

  final loadingKit = Center(
    child: Column(
      children: [
        SizedBox(height: 20),
        SpinKitSquareCircle(
          color: mainColor,
          size: 50.0,
        ),
        SizedBox(height: 10),
        Text("loading".tr())
      ],
    ),
  );

  Future<List<Order>> getOrders() async {
    List<Order> temp = await OrderServices.getOrders(
      currentPage.toString(),
      widget.keyword,
      widget.customerID,
      true,
    );
    orders = orders.isEmpty ? temp : orders;
    currentPage = currentPage + 1;
    isLoading = false;
    // setState(() {});

    return temp;
  }

  Future<void> getStoreData() async {
    Shop shop = await ShopService.getShopDetials();
    setState(() {
      link = shop.link;
      isPaid = shop.isPaidAccount == 1 ? true : false;
    });
  }

  @override
  void initState() {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    // getStoreData();
    setState(() {
      keyword.text = widget.keyword;
      isLoading = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.keyword == null && widget.customerID == null
          ? null
          : AppBar(
              elevation: 0,
              toolbarHeight: 100,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              leading: new IconButton(
                icon: FaIcon(FontAwesomeIcons.arrowRight, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Image.asset(
                "assets/images/logo.png",
                height: 40,
              ),
            ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(widget.keyword == null && widget.customerID == null ? 0 : 3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isPaid == null || isPaid == true
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          String url = 'https://eckit.co/upgrade';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.solidStar,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'upgrade_your_account'.tr(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'upgrade_your_account_des'.tr(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: const Color(0xff2ecc71),
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'welecome'.tr(),
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color(0xff1d1c1c),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (link == null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("loading".tr()),
                )
              else
                InkWell(
                  onTap: () async {
                    String url = 'https://store.eckit.co/$link';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'https://store.eckit.co/$link',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 20,
                                color: const Color(0xffffffff),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.externalLinkAlt,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'go_to_store'.tr(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: const Color(0xff1e272e),
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  FaIcon(FontAwesomeIcons.cartArrowDown),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "orders".tr(),
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              orders.isEmpty && !isLoading ? loadingKit : SizedBox.shrink(),
              orders.isEmpty && !isLoading
                  ? SizedBox.shrink()
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Pagination(
                          progress: loadingKit,
                          pageBuilder: (currentListSize) => getOrders(),
                          itemBuilder: (index, Order order) => ListItem(
                            id: order.id.toString(),
                            time: timeago.format((DateTime.parse(order.createdAt)), locale: 'ar'),
                            total: order.total.toString(),
                            currency: order.currency.toString(),
                            status: order.status.toString(),
                            items: order.items,
                            address: order.address.address,
                            customerName: order.customer.name,
                            customerNumber: order.customer.phoneNumber,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String id;
  final String address;
  final String time;
  final String status;
  final String total;
  final String customerName;
  final String customerNumber;
  final String currency;
  final List<Items> items;

  ListItem({
    this.address,
    this.id,
    this.time,
    this.total,
    this.status,
    this.currency,
    this.items,
    this.customerNumber,
    this.customerName,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#$id',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 23,
                        color: const Color(0xff8F8D8D),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      '$time',
                      style: TextStyle(
                        fontSize: 15,
                        color: const Color(0xff8F8D8D),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                Text(
                  status.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xffff7600),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '$address',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '$customerName',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '$customerNumber',
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xff3a3a3a),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '$total $currency',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff000000),
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 26,
                  child: Row(
                    children: [
                      Expanded(
                          child: CustomeButton(
                        title: "order_items".tr(),
                        icon: null,
                        handler: () => Navigator.pushNamed(context, '/orders_items', arguments: items),
                      )),
                      Expanded(
                          child: CustomeButton(
                        title: "change_order_status".tr(),
                        icon: null,
                        handler: () => Navigator.pushNamed(
                          context,
                          '/change_status',
                          arguments: ChangeOrderDetailsArguments(
                            currentStatus: status,
                            orderId: id,
                          ),
                        ),
                      )),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        Divider()
      ],
    );
  }
}

class ProductPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.cartArrowDown,
            size: 75,
            color: const Color(0xffe6d7d7),
          ),
          SizedBox(
            height: 12,
          ),
          Center(
            child: Text(
              'no_orders_yet'.tr(),
              style: TextStyle(
                fontSize: 25,
                color: const Color(0xffdbd3d3),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
