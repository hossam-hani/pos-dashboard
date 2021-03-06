import 'package:eckit/models/account.dart';
import 'package:eckit/models/category.dart';
import 'package:eckit/models/store.dart';
import 'package:eckit/models/supplier.dart';
import 'package:eckit/services/account_service.dart';
import 'package:eckit/services/stores_service.dart';
import 'package:eckit/services/suppliers_service.dart';
import '../../services/regions_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../components/customeButton.dart';
import 'package:paging/paging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../const.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../models/region.dart';
import 'usersEditor.dart';

class UsersList extends StatefulWidget {
  dynamic changePageHandler;
  dynamic changeCurrentIndex;

  UsersList({this.changePageHandler, this.changeCurrentIndex});

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<User> users = [];
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

  Future<List<User>> getStoresLocal() async {
    List<User> temp = await AccountService.getUsers(currentPage.toString());

    setState(() {
      users = users.isEmpty ? temp : users;
      currentPage = currentPage + 1;
      isLoading = false;
    });

    return temp;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
  }

  Future<void> _reloadData() async {
    setState(() {
      users.clear();
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
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: FaIcon(FontAwesomeIcons.times, color: Colors.black),
          ),
        ),
        title: Image.asset(
          "assets/images/logo.png",
          height: 40,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(FontAwesomeIcons.users),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "users".tr(),
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                CustomeButton(
                  title: "add_users",
                  icon: FontAwesomeIcons.plus,
                  handler: () => Navigator.pushNamed(
                    context,
                    '/users_editor',
                    arguments: UsersEditorArgumants(
                      onSaveFinish: _reloadData,
                    ),
                  ),
                ),
              ],
            ),
            users.isEmpty && !isLoading ? CategoryPlaceholder() : SizedBox(),
            users.isEmpty && !isLoading
                ? SizedBox()
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Pagination(
                        progress: loadingKit,
                        pageBuilder: (currentListSize) => getStoresLocal(),
                        itemBuilder: (index, User user) => ListItem(
                          onSaveFinish: _reloadData,
                          title: user.name.toString(),
                          id: user.id.toString(),
                          user: user,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  String title;
  String id;
  String image;
  String notes;
  User user;
  final VoidCallback onSaveFinish;

  ListItem({
    this.title,
    this.id,
    this.image,
    this.user,
    this.notes,
    @required this.onSaveFinish,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '/users_editor',
        arguments: UsersEditorArgumants(
          onSaveFinish: onSaveFinish,
          user: user,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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

                  //         Text(
                  //   '$notes',
                  //   style: TextStyle(
                  //       fontSize: 12,
                  //     color: const Color(0xff909090),
                  //     fontWeight: FontWeight.w100,
                  //   ),
                  //   textAlign: TextAlign.start,
                  // ),
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

class CategoryPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.mapMarked,
            size: 75,
            color: const Color(0xffe6d7d7),
          ),
          SizedBox(
            height: 12,
          ),
          Center(
            child: Text(
              'start_add_your_regions'.tr(),
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
              title: "add_region",
              icon: FontAwesomeIcons.plus,
              handler: () => Navigator.pushNamed(context, '/region_editor'),
            ),
          ),
        ],
      ),
    );
  }
}
