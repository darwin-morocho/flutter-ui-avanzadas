import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modernui/utils/config.dart';

class ChatAppBar extends StatelessWidget {
  final VoidCallback onOpenDrawer;
  const ChatAppBar({Key key, this.onOpenDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.primary),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: SvgPicture.asset(
                    'assets/chat/back.svg',
                    width: 25,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                SizedBox(width: 10),
                Text(
                  "Chat Bot",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: SvgPicture.asset(
                    'assets/chat/search.svg',
                    width: 25,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: SvgPicture.asset(
                    'assets/chat/menu.svg',
                    width: 25,
                    color: Colors.white,
                  ),
                  onPressed: onOpenDrawer,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
