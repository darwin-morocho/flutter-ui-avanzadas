import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyLocationSplashPage extends StatefulWidget {
  @override
  _MyLocationSplashPageState createState() => _MyLocationSplashPageState();
}

class _MyLocationSplashPageState extends State<MyLocationSplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(radius: 15),
      ),
    );
  }
}
