import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final VoidCallback onPressed;
  const RoundedButton(
      {Key key,
      this.fontSize = 15,
      @required this.text,
      this.color = const Color(0xff2979FF),
      @required this.onPressed})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          decoration: BoxDecoration(
              color: this.color.withOpacity(this.onPressed == null ? 0.5 : 1),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                    spreadRadius: 1)
              ],
              borderRadius: BorderRadius.circular(30)),
          child: Text(
            this.text,
            style: TextStyle(
                fontSize: this.fontSize,
                fontFamily: 'sans',
                letterSpacing: 1,
                fontWeight: FontWeight.w400,
                color: Colors.white),
          ),
        ),
        onPressed: this.onPressed);
  }
}
