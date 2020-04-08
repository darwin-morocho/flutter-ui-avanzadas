import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static Future<bool> confirm(BuildContext context,
      {String title, String body}) async {
    final c = Completer<bool>();
    showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return CupertinoActionSheet(
            title: title != null
                ? Text(title,
                    style: TextStyle(
                        fontFamily: 'sans',
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))
                : null,
            message: body != null
                ? Text(body,
                    style: TextStyle(
                        fontFamily: 'sans',
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w300))
                : null,
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text("ACCEPT"),
                onPressed: () {
                  Navigator.pop(_);
                  c.complete(true);
                },
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text("CANCEL"),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(_);
                c.complete(false);
              },
            ),
          );
        });

    return c.future;
  }
}
