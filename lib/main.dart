import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'route_generator.dart';

void main() {
  runApp(
    EasyLocalization(
      supportedLocales: [ Locale('ar', 'AR')],
      path: 'assets/translations',
      fallbackLocale: Locale('ar', 'AR'),
      child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Eckit',
      theme: ThemeData(
        fontFamily: "GESSMEDIUM",
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

