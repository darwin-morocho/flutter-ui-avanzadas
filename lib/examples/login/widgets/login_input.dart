import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginInput extends StatelessWidget {
  final String iconPath, placeholder;
  final bool obscureText;
  final TextInputType keyboardType;
  final void Function(String text) onChanged;
  const LoginInput(
      {Key key,
      @required this.iconPath,
      this.placeholder,
      this.obscureText = false,
      this.onChanged,
      this.keyboardType = TextInputType.text})
      : assert(iconPath != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      keyboardType: this.keyboardType,
      onChanged: this.onChanged,
      prefix: Container(
        width: 40,
        height: 25,
        padding: EdgeInsets.only(right: 5, left: 5),
        child: SvgPicture.asset(
          this.iconPath,
          color: Color(0xffaaaaaa),
        ),
      ),
      obscureText: this.obscureText,
      padding: EdgeInsets.symmetric(vertical: 10),
      placeholder: this.placeholder,
      placeholderStyle: TextStyle(
          fontFamily: 'sans', color: Color(0xffcccccc), letterSpacing: 1),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffdddddd)))),
    );
  }
}
