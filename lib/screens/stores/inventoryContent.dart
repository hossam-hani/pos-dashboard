import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paging/paging.dart';

import 'package:eckit/services/inventory_services.dart';
import 'package:eckit/services/product_service.dart';

import '../../components/customeButton.dart';
import '../../const.dart';
import '../../models/product.dart';

class InventoryContent extends StatefulWidget {
  final String inventoryId;

  InventoryContent({this.inventoryId});

  @override
  _InventoryContentState createState() => _InventoryContentState();
}

class _InventoryContentState extends State<InventoryContent> {
  List<Product> products = [];
  int currentPage = 1;
  bool isLoading = false;
  List<dynamic> quantities = [];

  final loadingKit = Center(
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

  Future<List<Product>> getProductsLocal() async {
    List<Product> temp = await ProductServices.getProducts(currentPage.toString(), null);

    setState(() {
      products = products.isEmpty ? temp : products;
      currentPage = currentPage + 1;
      isLoading = false;
    });

    return temp;
  }

  initData() async {
    List<dynamic> quantitiesTemp = await InventoryServices.getQuantities(inventroyId: widget.inventoryId);
    setState(() {
      quantities = quantitiesTemp;
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
    setState(() {
      isLoading = true;
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
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.arrowRight, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset("assets/images/logo.png", height: 40),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          products.isEmpty && !isLoading ? ProductPlaceholder() : SizedBox(),
          products.isEmpty && !isLoading
              ? SizedBox()
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Pagination(
                      progress: loadingKit,
                      pageBuilder: (currentListSize) => getProductsLocal(),
                      itemBuilder: (index, Product product) => ListItem(
                        title: product.name.toString(),
                        id: product.id.toString(),
                        quantity: quantities[index].toString(),
                        price: product.price.toString(),
                        currency: product.currency,
                        category: product.category.name.toString(),
                        product: product,
                        image: product.images.isNotEmpty ? product.images.first.imageUrl : null,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String title;
  final String id;
  final String price;
  final String category;
  final String currency;
  final String image;
  final String quantity;
  final Product product;

  const ListItem({
    this.title,
    this.id,
    this.price,
    this.category,
    this.currency,
    this.image,
    this.product,
    this.quantity,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/product_editor', arguments: product),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              image == null
                  ? FaIcon(
                      FontAwesomeIcons.box,
                      size: 55,
                      color: const Color(0xffe6d7d7),
                    )
                  : CachedNetworkImage(
                      height: 100,
                      width: 100,
                      imageUrl: image,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
              SizedBox(
                width: 25,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title',
                    style: TextStyle(
                      fontSize: 15,
                      color: const Color(0xff3a3a3a),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'الكمية : $quantity',
                    style: TextStyle(
                      fontSize: 15,
                      color: const Color(0xff3a3a3a),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '$category',
                    style: TextStyle(
                      fontSize: 10,
                      color: const Color(0xffe6d7d7),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              )
            ],
          ),
          const Divider(height: 0)
        ],
      ),
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
            FontAwesomeIcons.box,
            size: 75,
            color: const Color(0xffe6d7d7),
          ),
          SizedBox(
            height: 12,
          ),
          Center(
            child: Text(
              'start_add_your_products'.tr(),
              style: TextStyle(
                fontSize: 25,
                color: const Color(0xffdbd3d3),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          SizedBox(
            width: 200,
            child: CustomeButton(
              title: "add_product",
              icon: FontAwesomeIcons.plus,
              handler: () => Navigator.pushNamed(context, '/product_editor'),
            ),
          ),
        ],
      ),
    );
  }
}
