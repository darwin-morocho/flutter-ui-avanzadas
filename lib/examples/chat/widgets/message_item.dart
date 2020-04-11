import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modernui/examples/chat/models/message.dart';
import 'package:modernui/utils/config.dart';
import 'link_preview_viewer.dart';
import 'message_view.dart';
import 'slide_to_reply.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  final String myUserId;
  final VoidCallback onReply;
  final VoidCallback goToRepy;
  const MessageItem({
    Key key,
    @required this.message,
    @required this.myUserId,
    this.onReply,
    @required this.goToRepy,
  })  : assert(message != null && myUserId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    //print("build message item");
    final isMe = message.userId == myUserId;

    final isLinkOrImage =
        message.linkPreview != null || message.type == MessageType.image;

    final circularBorder = Radius.circular(20);
    final circularBorderNo = Radius.circular(0);

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
      width: double.infinity,
      child: Wrap(
        alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          if (!isMe)
            Container(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                'assets/chat/reddit.svg',
                color: AppColors.primary,
              ),
              margin: EdgeInsets.only(right: 10),
            ),
          SlideToReply(
            onReply: onReply,
            from:
                isMe ? SlideToReplyDirection.right : SlideToReplyDirection.left,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 270),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  // START REPLY TO MESSAGE
                  if (message.replyTo != null)
                    Transform.translate(
                      offset: Offset(0, 15),
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: 20,
                          left: 5,
                          right: 5,
                          top: 5,
                        ),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: AbsorbPointer(
                            absorbing: true,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      message.replyTo.type == MessageType.image
                                          ? 0
                                          : 10),
                              child: MessageView(
                                myUserId: myUserId,
                                message: message.replyTo,
                              ),
                            ),
                          ),
                          onPressed: goToRepy,
                        ),
                        decoration: BoxDecoration(
                          color: (message.replyTo.userId == myUserId
                                  ? AppColors.primary
                                  : AppColors.gray)
                              .withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  // END REPLY TO MESSAGE
                  Container(
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primary : AppColors.gray,
                      borderRadius: isLinkOrImage
                          ? BorderRadius.circular(isLinkOrImage ? 8 : 30)
                          : BorderRadius.only(
                              topLeft: isMe ? circularBorder : circularBorderNo,
                              topRight: circularBorder,
                              bottomLeft: circularBorder,
                              bottomRight:
                                  !isMe ? circularBorder : circularBorderNo,
                            ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isLinkOrImage ? 5 : 15,
                      vertical: isLinkOrImage ? 5 : 10,
                    ),
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
          ),
          if (message.sending)
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: CupertinoActivityIndicator(),
            )
        ],
      ),
    );
  }
}
