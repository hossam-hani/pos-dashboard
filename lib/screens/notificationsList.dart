import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eckit/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paging/paging.dart';

import 'package:eckit/models/Notification.dart';
import 'package:eckit/services/account_service.dart';

import '../components/customeButton.dart';
import '../const.dart';

class NotificationsList extends StatefulWidget {
  @override
  _NotificationsListState createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  List<NotificationModel> notifications = [];
  int currentPage = 1;
  bool isLoading = true;

  final Widget _loadingKit = Center(
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationHandler.get(context).clearNotificationMessagesNumber();
    });
    super.initState();
  }

  Future<List<NotificationModel>> getStoresLocal() async {
    List<NotificationModel> temp = await AccountService.getNotifications(currentPage.toString());

    setState(() {
      notifications = notifications.isEmpty ? temp : notifications;
      currentPage = currentPage + 1;
      isLoading = false;
    });

    return temp;
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
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(FontAwesomeIcons.solidBell),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "notifcations".tr(),
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            notifications.isEmpty && !isLoading ? CategoryPlaceholder() : SizedBox(),
            notifications.isEmpty && !isLoading
                ? SizedBox()
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Pagination(
                        progress: _loadingKit,
                        pageBuilder: (currentListSize) => getStoresLocal(),
                        itemBuilder: (index, NotificationModel notification) => ListItem(
                          title: notification.subject.toString(),
                          message: notification.message.toString(),
                          image: notification.img.toString(),
                          id: notification.id.toString(),
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
  final String title;
  final String id;
  final String image;
  final String message;
  final String notes;

  const ListItem({
    this.title,
    this.id,
    this.image,
    this.notes,
    this.message,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            image == null
                ? FaIcon(FontAwesomeIcons.box, size: 55, color: const Color(0xffe6d7d7))
                : CachedNetworkImage(
                    height: 50,
                    width: 50,
                    imageUrl: image,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
            SizedBox(width: 25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title',
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color(0xff3a3a3a),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    '$message',
                    style: TextStyle(
                      fontSize: 15,
                      color: const Color(0xff909090),
                      fontWeight: FontWeight.w100,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            )
          ],
        ),
        const Divider()
      ],
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
          SizedBox(height: 12),
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
          SizedBox(height: 12),
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
