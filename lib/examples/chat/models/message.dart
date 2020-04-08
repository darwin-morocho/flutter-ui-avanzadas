import 'package:meta/meta.dart' show required;
import 'package:modernui/examples/chat/models/link_preview.dart';

class Message {
  final String id, value, type, userId;
  final Message replyTo;
  final LinkPreview linkPreview;
  final bool sending;

  Message(
      {@required this.id,
      @required this.userId,
      @required this.value,
      @required this.type,
      this.linkPreview,
      this.sending = false,
      this.replyTo})
      : assert(id != null && value != null && type != null && userId != null);

  Message copyWith({Message replyTo, LinkPreview linkPreview, bool sending}) {
    return Message(
        id: this.id,
        userId: this.userId,
        value: this.value,
        type: this.type,
        sending: sending ?? this.sending,
        replyTo: replyTo ?? this.replyTo,
        linkPreview: linkPreview ?? this.linkPreview);
  }
}

class MessageType {
  static final text = "text";
  static final image = "image";
  static final audio = 'audio';
}
