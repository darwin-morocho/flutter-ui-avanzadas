import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modernui/examples/chat/pages/chat_page.dart';
import 'package:modernui/examples/deezer/deezer_page.dart';
import 'package:modernui/examples/login/login_page.dart';
import 'package:modernui/examples/my_location/pages/my_location_missing_permission_page.dart';
import 'package:modernui/examples/my_location/pages/my_location_pages.dart';
import 'package:modernui/utils/config.dart';
import 'package:modernui/widgets/rounded_button.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final routes = {
      LoginPage.routeName: (_) => LoginPage(),
      MyLocationPages.missingPermission: (_) =>
          MyLocationMissingPermissionPage(),
      ChatPage.routeName: (_) => ChatPage(),
      DeezerPage.routeName: (_) => DeezerPage()
    };
    return MaterialApp(
      theme: ThemeData(fontFamily: 'sans', platform: TargetPlatform.iOS),
      home: HomePage(
        routes: routes,
      ),
      debugShowCheckedModeBanner: false,
      routes: routes,
    );
  }
}

class HomePage extends StatelessWidget {
  final Map<String, Widget Function(BuildContext)> routes;

  const HomePage({Key key, @required this.routes})
      : assert(routes != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: size.width * 0.05,
              left: size.width * 0.27,
              child: Container(
                width: size.width * 0.3,
                height: size.width * 0.3,
                decoration: BoxDecoration(
                  color: AppColors.gray,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: -size.width * 0.3,
              left: -size.width * 0.2,
              child: Container(
                width: size.width * 0.6,
                height: size.width * 0.6,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: -size.width * 0.2,
              right: -size.width * 0.2,
              child: Container(
                width: size.width * 0.7,
                height: size.width * 0.7,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              child: FlareActor(
                "assets/rive/flip.flr",
                alignment: Alignment.center,
                animation: 'idle',
                fit: BoxFit.cover,
                sizeFromArtboard: true,
              ),
              left: -size.width * 0.2,
              height: size.height,
              width: size.width,
              bottom: -size.height * 0.07,
            ),
            Positioned(
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Choose the",
                        style: TextStyle(
                            fontSize: 18,
                            height: 0.7,
                            fontWeight: FontWeight.bold)),
                    Text(
                      "Example",
                      style: TextStyle(
                          fontSize: 30, height: 1, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ...routes.keys
                        .map<Widget>(
                          (key) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                            child: RoundedButton(
                              text: key,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              color: AppColors.primary,
                              onPressed: () {
                                Navigator.pushNamed(context, key);
                              },
                            ),
                          ),
                        )
                        .toList()
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
