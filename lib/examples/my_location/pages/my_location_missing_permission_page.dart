import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modernui/examples/my_location/widgets/fade_up.dart';
import 'package:modernui/utils/responsive.dart';
import 'package:modernui/widgets/rounded_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyLocationMissingPermissionPage extends StatefulWidget {
  @override
  _MyLocationMissingPermissionPageState createState() =>
      _MyLocationMissingPermissionPageState();
}

class _MyLocationMissingPermissionPageState
    extends State<MyLocationMissingPermissionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.init(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: LayoutBuilder(
                    builder: (_, constraints) {
                      return Stack(
                        children: <Widget>[
                          Transform.translate(
                            offset: Offset(constraints.maxWidth * 0.015,
                                -constraints.maxHeight * 0.35),
                            child: SpinKitRipple(
                              borderWidth: 40,
                              size: constraints.maxHeight * 0.8,
                              duration: Duration(seconds: 2),
                              color: Color(0xffF50057).withOpacity(0.3),
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/my_location/best_place.svg',
                          )
                        ],
                      );
                    },
                  ),
                ),
                FadeUp(
                    from: responsive.height * 0.3,
                    duration: Duration(milliseconds: 500),
                    delayed: 100,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 340),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "MISSING PERMISSION",
                            style: TextStyle(
                                fontFamily: 'raleway',
                                fontSize: responsive.ip(2.2),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit do, sed do eiusmod tempor.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: responsive.ip(1.6),
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(height: 20),
                          RoundedButton(
                            text: "ALLOW",
                            fontSize: responsive.ip(2),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
