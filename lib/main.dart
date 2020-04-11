import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modernui/examples/chat/pages/chat_page.dart';
import 'package:modernui/examples/login/login_page.dart';
import 'package:modernui/examples/my_location/pages/my_location_missing_permission_page.dart';
import 'package:modernui/examples/my_location/pages/my_location_pages.dart';
import 'package:modernui/examples/my_location/pages/my_location_splash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'sans', platform: TargetPlatform.iOS),
      home: ChatPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        MyLocationPages.splash: (_) => MyLocationSplashPage(),
        MyLocationPages.missingPermission: (_) =>
            MyLocationMissingPermissionPage(),
        LoginPage.routeName: (_) => LoginPage()
      },
    );
  }
}
