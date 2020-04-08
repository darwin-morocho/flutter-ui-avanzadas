import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DraggableIcon extends StatelessWidget {
  final String iconPath;
  final Color color, backgroundColor;
  const DraggableIcon(
      {Key key,
      @required this.iconPath,
      this.color = Colors.black,
      this.backgroundColor = const Color(0xfff7f7f7)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: this.backgroundColor,
      ),
      padding: EdgeInsets.symmetric(vertical: 12),
      child: SvgPicture.asset(
        this.iconPath,
        color: this.color,
      ),
    );
  }
}