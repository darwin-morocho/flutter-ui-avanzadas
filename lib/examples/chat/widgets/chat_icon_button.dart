import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatIconButton extends StatelessWidget {
  final String iconPath;
  final double size;
  final VoidCallback onPressed;
  const ChatIconButton(
      {Key key, @required this.iconPath, this.onPressed, this.size = 40})
      : assert(iconPath != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 25,
        child: Container(
          width: this.size,
          height: this.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xfff7f7f7),
          ),
          padding: EdgeInsets.symmetric(vertical: this.size / 5),
          child: SvgPicture.asset(
            this.iconPath,
            color: Colors.black,
          ),
        ),
        onPressed: this.onPressed);
  }
}
