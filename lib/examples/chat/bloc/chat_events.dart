import 'dart:async';

import 'package:modernui/examples/chat/models/message.dart';

abstract class ChatEvents {}

class ChatSendEvent extends ChatEvents {
  Completer<bool> completer;
  final Message message;

  ChatSendEvent(this.message);

  Future<bool> send() async {
    completer = Completer();
    return completer.future;
  }
}

class ChatReplyToEvent extends ChatEvents {
  final Message message;
  ChatReplyToEvent(this.message);
}
