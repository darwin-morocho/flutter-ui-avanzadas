import 'package:flutter/material.dart';
import 'package:modernui/examples/chat/models/message.dart';

import 'audio_player.dart';

class MessageView extends StatelessWidget {
  final String myUserId;
  final Message message;
  const MessageView({Key key, @required this.message, @required this.myUserId})
      : assert(message != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMe = myUserId != null && myUserId == message.userId;

    if (message.type == MessageType.text) {
      return Text(message.value,
          style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
              fontFamily: 'sans',
              height: 1.1,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w300));
    } else if (message.type == MessageType.audio) {
      return AudioPlayer(fileUri: message.value);
    } else if (message.type == MessageType.image) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: 200,
          child: message.sending
              ? Image.file(message.file)
              : Image.network(message.value),
        ),
      );
    }

    return Container();
  }
}
