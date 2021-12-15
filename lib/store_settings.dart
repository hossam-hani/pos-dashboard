import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:eckit/components/customeButton.dart';
import 'package:eckit/models/account.dart';
import 'package:eckit/services/orders_service.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'components/date_range_picker.dart';
import 'const.dart';
import 'dart:ui' as ui;

import 'package:intl/intl.dart';

class StoreSettings extends StatefulWidget {
  dynamic changePageHandler;

  StoreSettings({this.changePageHandler});

  @override
  _StoreSettingsState createState() => _StoreSettingsState();
}

class _StoreSettingsState extends State<StoreSettings> {
  DateTime startFrom = DateTime.now();
  DateTime endAt = DateTime.now();

  bool isLoading = false;
  String sales;
  String expenses;
  String ordersNumbers;
  String customers;
  String currency;
  String graph = "monthSales"; // weekSales monthSales salesVsConsts
  GraphDataForSalesAndCosts graphDataForSalesAndCosts;

  search() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Account currentUser = Account.fromJson(jsonDecode(prefs.getString("account")));

    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer " + currentUser.accessToken;

    try {
      Response response = await dio.post("$baseUrl/reports", data: {
        "startAt": DateFormat('yyyy-MM-dd').format(startFrom),
        "endAt": DateFormat('yyyy-MM-dd').format(endAt),
      });

      setState(() {
        sales = response.data["sales"].toString();
        expenses = response.data["expenses"].toString();
        customers = response.data["customerNo"].toString();
        ordersNumbers = response.data["orderNo"].toString();
        currency = response.data["currency"].toString();
      });
    } catch (e) {}

    setState(() {
      isLoading = false;
    });
  }

  bool isLoadingGraph = true;

  getGraphData(type) async {
    setState(() {
      isLoadingGraph = true;
    });
    GraphDataForSalesAndCosts graphDataForSalesAndCostsTemp = await OrderServices.getGraphData(type);
    print(graphDataForSalesAndCostsTemp);
    setState(() {
      graphDataForSalesAndCosts = graphDataForSalesAndCostsTemp;
      isLoadingGraph = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getGraphData("perweekinthismonth");
  }

  var loadingKit = Center(
    child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        SpinKitSquareCircle(
          color: mainColor,
          size: 50.0,
        ),
        SizedBox(
          height: 10,
        ),
        Text("loading".tr())
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    List<_SalesData> data = [
      _SalesData('Jan', 35),
      _SalesData('Feb', 28),
      _SalesData('Mar', 34),
      _SalesData('Apr', 32),
      _SalesData('May', 40)
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),

          Row(
            children: [
              FaIcon(FontAwesomeIcons.store),
              SizedBox(
                width: 10,
              ),
              Text(
                "store".tr(),
                style: TextStyle(fontSize: 20),
              )
            ],
          ),

          SizedBox(
            height: 10,
          ),

          Row(
            children: [
              Expanded(
                child: CustomeButton(
                  title: "العملاء",
                  handler: () async {
                    Navigator.pushNamed(context, '/customers_reports');
                  },
                ),
              ),
              Expanded(
                child: CustomeButton(
                  title: "اذونات السداد",
                  handler: () async {
                    Navigator.pushNamed(context, '/transactions_reports', arguments: {
                      "startAt": null,
                      "endAt": null,
                      "customerId": null,
                    });
                  },
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: CustomeButton(
                  title: "المصاريف",
                  handler: () async {
                    Navigator.pushNamed(context, '/costs_reports', arguments: {
                      "startAt": null,
                      "endAt": null,
                      "type": null,
                    });
                  },
                ),
              ),
              Expanded(
                child: CustomeButton(
                  title: "الزيارات",
                  handler: () async {
                    Navigator.pushNamed(context, '/vstists_reports', arguments: {
                      "startAt": null,
                      "endAt": null,
                      "customerId": null,
                      "userId": null,
                    });
                  },
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: CustomeButton(
                  title: "الفواتير",
                  handler: () async {
                    Navigator.pushNamed(context, '/orders_reports', arguments: {
                      "startAt": null,
                      "endAt": null,
                      "customerId": null,
                    });
                  },
                ),
              ),
              Expanded(
                child: CustomeButton(
                  title: "المشتريات",
                  handler: () async {
                    Navigator.pushNamed(context, '/suppliers_invoices', arguments: {
                      "startAt": null,
                      "endAt": null,
                      "supplierId": null,
                    });
                  },
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: CustomeButton(
                  title: "التكاليف",
                  handler: () {
                    Navigator.pushNamed(context, '/costs_reports', arguments: {
                      "startAt": null,
                      "endAt": null,
                      "type": null,
                    });
                  },
                ),
              ),
            ],
          ),

          CustomeButton(
            title: "الضريبة",
            handler: () async {
              Navigator.pushNamed(context, '/taxes_editor');
            },
          ),

          Divider(),

          CustomeButton(
            title: "edit_store_settings".tr(),
            handler: () => {Navigator.pushNamed(context, '/edit_shop_details')},
          ),

          DateRangePicker(
            from: startFrom,
            to: endAt,
            onChanged: (from, to) {
              if (mounted) {
                setState(() {
                  startFrom = from;
                  endAt = to;
                });
              }
            },
          ),

          CustomeButton(
            title: "confirm".tr(),
            handler: search,
          ),

          isLoading
              ? loadingKit
              : sales == null
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          DataItem(
                            lable: "المبيعات",
                            contenct: "$sales $currency",
                            icon: FaIcon(
                              FontAwesomeIcons.dollarSign,
                              color: Colors.white,
                            ),
                          ),
                          DataItem(
                            lable: "المصاريف",
                            contenct: "$expenses $currency",
                            icon: FaIcon(
                              FontAwesomeIcons.dollarSign,
                              color: Colors.white,
                            ),
                          ),
                          DataItem(
                            lable: "الصافي",
                            contenct: "${double.parse(sales) - double.parse(expenses)} $currency",
                            icon: FaIcon(
                              FontAwesomeIcons.dollarSign,
                              color: Colors.white,
                            ),
                          ),
                          DataItem(
                            lable: "عدد الفواتير",
                            contenct: "$ordersNumbers",
                            icon: FaIcon(
                              FontAwesomeIcons.cartArrowDown,
                              color: Colors.white,
                            ),
                          ),
                          DataItem(
                            lable: "عدد العملاء",
                            contenct: "$customers",
                            icon: FaIcon(
                              FontAwesomeIcons.users,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

          SizedBox(
            height: 10,
          ),

          Divider(),
          Text("الرسوم البيانية للمبيعات و المصاريف"),

          Row(
            children: [
              Expanded(
                child: CustomeButton(
                  title: "اسبوعيا خلال الشهر",
                  handler: () async {
                    getGraphData("perweekinthismonth");
                  },
                ),
              ),
              Expanded(
                child: CustomeButton(
                  title: "يوميا خلال الشهر",
                  handler: () async {
                    getGraphData("perdayinthismonth");
                  },
                ),
              ),
            ],
          ),

          // Initialize the chart widget
          //   SfCartesianChart(
          //       primaryXAxis: CategoryAxis(),
          //       // Chart title
          //       title: ChartTitle(text: 'تقرير المبيعات لاخر 6'),
          //       // Enable legend
          //       legend: Legend(isVisible: true),

          //       // Enable tooltip
          //       tooltipBehavior: TooltipBehavior(enable: true),
          //       series: <ChartSeries<_SalesData, String>>[
          //         LineSeries<_SalesData, String>(
          //             dataSource: data,
          //             xValueMapper: (_SalesData sales, _) => sales.year,
          //             yValueMapper: (_SalesData sales, _) => sales.sales,
          //             name: 'Sales',
          //             // Enable data label
          //             dataLabelSettings: DataLabelSettings(isVisible: true))
          // ]),

          // weekSales monthSales salesVsConsts

          isLoadingGraph && graphDataForSalesAndCosts == null
              ? Text("جاري التحميل")
              : Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: _buildDefaultLineChart("monthSales", graphDataForSalesAndCosts)))
        ],
      ),
    );
  }
}

class DataItem extends StatelessWidget {
  String lable;
  String contenct;
  FaIcon icon;

  DataItem({this.lable, this.contenct, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          lable,
          style: TextStyle(
            fontSize: 20,
            color: const Color(0xff000000),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 51.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color(0xff1e272e),
          ),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon != null ? icon : SizedBox(),
                SizedBox(
                  width: 10,
                ),
                Text(
                  contenct,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 15,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

/// Get the cartesian chart with default line series
Widget _buildDefaultLineChart(String graph, GraphDataForSalesAndCosts graphDataForSalesAndCosts) {
  return Directionality(
    textDirection: ui.TextDirection.rtl,
    child: SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: graphDataForSalesAndCosts.sales.length == 4 ? 'المبيعات الاسبوعية' : 'المبيعات الشهرية'),
      // legend: Legend(
      // isVisible:  true,
      // overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: NumericAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interval: 1,
          labelFormat: graphDataForSalesAndCosts.sales.length == 4 ? '{value} الأسبوع' : '{value}',
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          labelFormat: '{value} EGP',
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(color: Colors.transparent)),
      series: _getDefaultLineSeries(graphDataForSalesAndCosts),
      tooltipBehavior: TooltipBehavior(enable: true),
    ),
  );
}

/// The method returns line series to chart.
List<LineSeries<_ChartData, num>> _getDefaultLineSeries(GraphDataForSalesAndCosts graphDataForSalesAndCosts) {
  List<_ChartData> chartData = <_ChartData>[];
  if (graphDataForSalesAndCosts != null) {
    for (int i = 0; i < graphDataForSalesAndCosts.sales.length; i++) {
      chartData.add(_ChartData(i + 1, graphDataForSalesAndCosts.sales[i],
          graphDataForSalesAndCosts.sales.length == 4 ? 0 : graphDataForSalesAndCosts.costs[i]));
    }
  }

  return <LineSeries<_ChartData, num>>[
    LineSeries<_ChartData, num>(
        animationDuration: 2500,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        width: 2,
        name: 'المبيعات',
        markerSettings: const MarkerSettings(isVisible: true)),
    LineSeries<_ChartData, num>(
        animationDuration: 2500,
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y2,
        width: 2,
        name: 'المصاريف',
        markerSettings: const MarkerSettings(isVisible: false)),
  ];
}

class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  final num x;
  final num y;
  final num y2;
}
