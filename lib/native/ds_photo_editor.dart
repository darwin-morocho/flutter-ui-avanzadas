import 'package:flutter/services.dart';

class DSPhotoEditor {
  final _channel = MethodChannel('ec.dina/ds-photo-editor');

  pick() async {
    await _channel.invokeMethod("pick");
  }
}
