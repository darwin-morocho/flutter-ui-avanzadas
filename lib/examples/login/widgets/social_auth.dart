import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialAuth extends StatelessWidget {
  const SocialAuth({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CupertinoButton(
            padding: EdgeInsets.zero,
            child: ClipOval(
              child: Container(
                width: 55,
                height: 55,
                color: Colors.blueAccent,
                padding: EdgeInsets.all(13),
                child: SvgPicture.asset(
                  'assets/login/facebook.svg',
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: () {}),
        SizedBox(
          width: 20,
        ),
        CupertinoButton(
            padding: EdgeInsets.zero,
            child: ClipOval(
              child: Container(
                width: 55,
                height: 55,
                padding: EdgeInsets.all(13),
                color: Colors.redAccent,
                child: SvgPicture.asset(
                  'assets/login/google.svg',
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: () {})
      ],
    );
  }
}
