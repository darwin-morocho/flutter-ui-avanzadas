import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modernui/examples/chat/models/message.dart';
import 'package:modernui/utils/config.dart';
import 'audio_player.dart';
import 'link_preview_viewer.dart';
import 'message_view.dart';
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

    final isLinkOrImage =
        message.linkPreview != null || message.type == MessageType.image;

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
                              bottom: 20, left: 5, right: 5, top: 5),
                          child: MessageView(
                            myUserId: myUserId,
                            message: message.replyTo,
                          ),
                          decoration: BoxDecoration(
                              color: (message.replyTo.userId == myUserId
                                      ? AppColors.primary
                                      : AppColors.gray)
                                  .withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10)),
                        )),
                  Container(
                    decoration: BoxDecoration(
                        color: isMe ? AppColors.primary : AppColors.gray,
                        borderRadius:
                            BorderRadius.circular(isLinkOrImage ? 8 : 30)),
                    padding: EdgeInsets.symmetric(
                        horizontal: isLinkOrImage ? 5 : 15,
                        vertical: isLinkOrImage ? 5 : 10),
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
