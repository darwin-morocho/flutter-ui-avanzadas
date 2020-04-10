import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modernui/examples/chat/models/message.dart';
import 'package:modernui/examples/chat/pages/photo_view.dart';

import 'audio_player.dart';

class MessageView extends StatelessWidget {
  final String myUserId;
  final Message message;
  final bool isInsideReplyTo;
  const MessageView(
      {Key key,
      @required this.message,
      @required this.myUserId,
      this.isInsideReplyTo = false})
      : assert(message != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMe = myUserId != null && myUserId == message.userId;

    if (message.type == MessageType.text) {
      return Text(
        message.value,
        style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontFamily: 'sans',
            height: 1.1,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w300),
      );
    } else if (message.type == MessageType.audio) {
      return AudioPlayer(fileUri: message.value);
    } else if (message.type == MessageType.image) {
      final heroTag = "${DateTime.now().millisecondsSinceEpoch}${message.id}";
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
            height: isInsideReplyTo ? 100 : 150,
            width: isInsideReplyTo ? 100 : 150,
            color: Colors.white,
            child: Hero(
              tag: heroTag,
              child: message.sending && message.file != null
                  ? Image.file(message.file)
                  : CachedNetworkImage(
                      imageUrl: message.value,
                      placeholder: (_, __) => Center(
                        child: CupertinoActivityIndicator(
                          radius: 15,
                        ),
                      ),
                    ),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PhotoViewPage(
                  heroTag: heroTag,
                  imageData: message.value,
                  fromNetwork: !message.sending || message.sending == null,
                ),
              ),
            );
          },
        ),
      );
    }

    return Container();
  }
}
