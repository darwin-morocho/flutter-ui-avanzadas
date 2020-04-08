import 'package:equatable/equatable.dart';
import 'package:modernui/examples/chat/models/message.dart';

class ChatState extends Equatable {
  final List<Message> messages;
  final Message replyTo;

  ChatState({this.messages = const [], this.replyTo});

  ChatState copyWith({List<Message> messages, Message replyTo}) {
    return ChatState(
        messages: messages ?? this.messages, replyTo: replyTo ?? this.replyTo);
  }

  ChatState setReplyTo(Message replyTo, {List<Message> messages}) {
    return ChatState(messages: messages ?? this.messages, replyTo: replyTo);
  }

  @override
  List<Object> get props => [messages, replyTo];
}
