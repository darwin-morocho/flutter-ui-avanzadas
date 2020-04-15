import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart' show required;
import 'package:modernui/examples/chat/models/link_preview.dart';

class Message {
  final String id, value, type, userId;
  final Message replyTo;
  final LinkPreview linkPreview;
  final bool sending;
  final File file;

  Message(
      {@required this.id,
      @required this.userId,
      @required this.value,
      @required this.type,
      this.linkPreview,
      this.sending = false,
      this.file,
      this.replyTo})
      : assert(id != null && value != null && type != null && userId != null);

  Message copyWith(
      {String value,
      Message replyTo,
      LinkPreview linkPreview,
      bool sending,
      String type,
      File file}) {
    return Message(
        id: this.id,
        userId: this.userId,
        value: value ?? this.value,
        sending: sending ?? this.sending,
        replyTo: replyTo ?? this.replyTo,
        file: file ?? this.file,
        type: type ?? this.type,
        linkPreview: linkPreview ?? this.linkPreview);
  }
}

class MessageType {
  static final text = "text";
  static final image = "image";
  static final audio = 'audio';
}
