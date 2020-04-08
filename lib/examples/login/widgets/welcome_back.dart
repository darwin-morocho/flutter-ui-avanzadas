import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeBack extends StatelessWidget {
  const WelcomeBack({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: AspectRatio(
        aspectRatio: 16 / 9,
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Stack(
              children: <Widget>[
                Transform.translate(
                    offset: Offset(0, -constraints.maxHeight *0.4),
                    child: SvgPicture.asset('assets/login/behind.svg')),
                Positioned(
                  top: constraints.maxHeight * 0.6,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 3,
                        color: Color(0xfff0f0f0),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'raleway',
                            fontSize: 25),
                      )
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  top: constraints.maxHeight * 0.12,
                  child: SvgPicture.asset('assets/login/woman.svg',
                      height: constraints.maxHeight * 0.5),
                ),
                Positioned(
                  right: 0,
                  top: constraints.maxHeight * 0.13,
                  child: SvgPicture.asset(
                    'assets/login/man.svg',
                    height: constraints.maxHeight * 0.8,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
