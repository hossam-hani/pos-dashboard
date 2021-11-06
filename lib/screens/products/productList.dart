import 'package:eckit/models/category.dart';
import 'package:eckit/screens/products/productEditor.dart';
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

class ProductList extends StatefulWidget {
  dynamic changePageHandler;
  dynamic changeCurrentIndex;
  String categoryId;

  ProductList({this.changePageHandler, this.changeCurrentIndex, this.categoryId});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Category> categories;
  List<Product> products = [];
  int currentPage = 1;
  bool isLoading = false;

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

  Future<List<Product>> getProductsLocal() async {
    List<Product> temp = await ProductServices.getProducts(currentPage.toString(), widget.categoryId);

    print(temp);
    setState(() {
      products = products.isEmpty ? temp : products;
      currentPage = currentPage + 1;
      isLoading = false;
    });

    return temp;
  }

  getCategories() async {
    List<Category> temp = await CategoryServices.getAllCategories();

    setState(() {
      categories = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    getCategories();
    setState(() {
      isLoading = true;
    });
  }

  Future<void> _reloadData() async {
    setState(() {
      products.clear();
      currentPage = 1;
      isLoading = false;
    });
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.categoryId == null
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
              )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(FontAwesomeIcons.boxes),
              SizedBox(
                width: 10,
              ),
              Text(
                "products".tr(),
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          widget.categoryId != null
              ? SizedBox()
              : Row(
                  children: [
                    CustomeButton(
                      title: "add_product",
                      icon: FontAwesomeIcons.plus,
                      handler: () => Navigator.pushNamed(
                        context,
                        '/product_editor',
                        arguments: ProductEditorArgumants(
                          onSaveFinish: _reloadData,
                        ),
                      ),
                    ),
                    CustomeButton(
                      title: "categories",
                      icon: FontAwesomeIcons.tags,
                      handler: () => widget.changeCurrentIndex(5),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => new AlertDialog(
                                          title: new Text("search".tr()),
                                          content: Column(
                                            children: [
                                              categories == null
                                                  ? SizedBox()
                                                  : DropdownButton<Category>(
                                                      isExpanded: true,
                                                      items: categories.map((Category category) {
                                                        return new DropdownMenuItem<Category>(
                                                          value: category,
                                                          child: new Text(category.name),
                                                        );
                                                      }).toList(),
                                                      hint: Text("select_category_hint".tr()),
                                                      onChanged: (newValue) {
                                                        Navigator.of(context).pop();
                                                        Navigator.pushNamed(context, '/products',
                                                            arguments: newValue.id.toString());
                                                      },
                                                    ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('close'.tr()),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        ));
                              },
                              child: FaIcon(FontAwesomeIcons.filter)),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    )
                  ],
                ),
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
                        onSaveFinish: _reloadData,
                        title: product.name.toString(),
                        id: product.id.toString(),
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
  final Product product;
  final VoidCallback onSaveFinish;

  ListItem({
    this.title,
    this.id,
    this.price,
    this.category,
    this.currency,
    this.image,
    this.product,
    @required this.onSaveFinish,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/product_editor',
          arguments: ProductEditorArgumants(
            onSaveFinish: onSaveFinish,
            product: product,
          )),
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
                  Text(
                    '$price $currency',
                    style: TextStyle(
                      fontFamily: 'Lato',
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
          Divider()
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
              )),
        ],
      ),
    );
  }
}
