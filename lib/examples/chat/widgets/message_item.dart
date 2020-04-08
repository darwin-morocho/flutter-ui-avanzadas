import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modernui/examples/chat/models/message.dart';
import 'package:modernui/utils/config.dart';
import 'audio_player.dart';
import 'link_preview_viewer.dart';
import 'slide_to_reply.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  final String myUserId;
  final VoidCallback onReply;
  const MessageItem(
      {Key key, @required this.message, @required this.myUserId, this.onReply})
      : assert(message != null && myUserId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    //print("build message item");
    final isMe = message.userId == myUserId;

    return SlideToReply(
      onReply: onReply,
      from: isMe ? SlideToReplyDirection.right : SlideToReplyDirection.left,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Wrap(
          alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 300),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  if (message.replyTo != null)
                    Transform.translate(
                        offset: Offset(0, 15),
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: 20, left: 10, right: 10, top: 10),
                          child: MessageView(
                            myUserId: myUserId,
                            message: message.replyTo,
                          ),
                          decoration: BoxDecoration(
                              color: (message.replyTo.userId == myUserId
                                      ? AppColors.primary
                                      : AppColors.gray)
                                  .withOpacity(0.9),
                              borderRadius: BorderRadius.circular(10)),
                        )),
                  Container(
                    decoration: BoxDecoration(
                        color: isMe ? AppColors.primary : AppColors.gray,
                        borderRadius: BorderRadius.circular(
                            message.linkPreview == null ? 30 : 8)),
                    padding: EdgeInsets.symmetric(
                        horizontal: message.linkPreview == null ? 15 : 5,
                        vertical: message.linkPreview == null ? 10 : 5),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        LinkPreviewViewer(linkPreview: message.linkPreview),
                        MessageView(myUserId: myUserId, message: message)
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (message.sending)
              Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: CupertinoActivityIndicator())
          ],
        ),
      ),
    );
  }
}

class MessageView extends StatelessWidget {
  final String myUserId;
  final Message message;
  const MessageView({Key key, @required this.message, @required this.myUserId})
      : assert(message != null && myUserId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMe = myUserId == message.userId;

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
    }

    return Container();
  }
}
