import 'package:flutter/material.dart';
import 'package:modernui/utils/dialogs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:modernui/widgets/rounded_button.dart';

class ChatMissingPermission extends StatefulWidget {
  final Permission permission;
  final VoidCallback onGranted;
  final String title, description;

  const ChatMissingPermission(
      {Key key,
      @required this.permission,
      @required this.onGranted,
      this.title = "Missing permission",
      @required this.description})
      : assert(permission != null && onGranted != null),
        super(key: key);
  @override
  _ChatMissingPermissionState createState() => _ChatMissingPermissionState();
}

class _ChatMissingPermissionState extends State<ChatMissingPermission>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAgain();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _checkAgain() async {
    final bool isGranted = await widget.permission.isGranted;
    if (isGranted) {
      widget.onGranted();
    }
  }

  _request() async {
    final PermissionStatus status = await widget.permission.request();
    if (status == PermissionStatus.granted) {
      widget.onGranted();
    } else if (status == PermissionStatus.denied) {
      final isOk = await Dialogs.confirm(context,
          title: "ACTION REQUIRED",
          body:
              "We need acces to your microphone plesase go to your app settings and enable the access.");
      if (isOk) {
        openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),
          Text(
            widget.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            widget.description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 15),
          RoundedButton(text: "ALLOW", onPressed: _request)
        ],
      ),
    );
  }
}
