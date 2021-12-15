import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerContent extends StatefulWidget {
  @override
  _DrawerContentState createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/regions');
            },
            child: ListTile(
              title: Text('regions'.tr()),
              subtitle: Text('regions_des'.tr()),
              leading: FaIcon(FontAwesomeIcons.mapMarked),
              isThreeLine: true,
            ),
          ),

          // InkWell(
          //     onTap: (){
          //       Navigator.pushNamed(context, '/points_editor');
          //     },
          //     child: ListTile(
          //     title: Text('points'.tr()),
          //     subtitle: Text(
          //       'points_des'.tr()
          //     ),
          //     leading: FaIcon(FontAwesomeIcons.coins),
          //     isThreeLine: true,
          //   ),
          // ),

          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/suppliers');
            },
            child: ListTile(
              title: Text('suppliers'.tr()),
              subtitle: Text('suppliers_des'.tr()),
              leading: FaIcon(FontAwesomeIcons.users),
              isThreeLine: true,
            ),
          ),

          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/stores');
            },
            child: ListTile(
              title: Text('stores'.tr()),
              subtitle: Text('stores_des'.tr()),
              leading: FaIcon(FontAwesomeIcons.warehouse),
              isThreeLine: true,
            ),
          ),

          // InkWell(
          //     onTap: (){
          //       Navigator.pushNamed(context, '/transactions');
          //     },
          //     child: ListTile(
          //     title: Text('transactions'.tr()),
          //     subtitle: Text(
          //       'transactions_des'.tr()
          //     ),
          //     leading: FaIcon(FontAwesomeIcons.dollarSign),
          //     isThreeLine: true,
          //   ),
          // ),

          // InkWell(
          //     onTap: (){
          //       Navigator.pushNamed(context, '/stocks');
          //     },
          //     child: ListTile(
          //     title: Text('stocks'.tr()),
          //     subtitle: Text(
          //       'stocks_des'.tr()
          //     ),
          //     leading: FaIcon(FontAwesomeIcons.boxes),
          //     isThreeLine: true,
          //   ),
          // ),

          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/users');
            },
            child: ListTile(
              title: Text('users'.tr()),
              subtitle: Text('users_des'.tr()),
              leading: FaIcon(FontAwesomeIcons.boxes),
              isThreeLine: true,
            ),
          ),
          const Divider(height: 0),
          InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("account");
              Navigator.pushNamed(context, '/login');
            },
            child: ListTile(
              title: Text('تسجيل الخروج'),
              leading: FaIcon(Icons.logout),
            ),
          ),
        ],
      ),
    );
  }
}
