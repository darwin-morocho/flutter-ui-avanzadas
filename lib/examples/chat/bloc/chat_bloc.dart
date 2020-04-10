import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modernui/examples/chat/api/witai.dart';
import 'package:modernui/examples/chat/models/link_preview.dart';
import 'package:modernui/examples/chat/models/message.dart';
import 'package:modernui/utils/extras.dart';
import 'chat_events.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvents, ChatState> {
  final WitAI _witAI = WitAI();

  @override
  ChatState get initialState => ChatState();

  @override
  Stream<ChatState> mapEventToState(ChatEvents event) async* {
    if (event is ChatSendEvent) {
      yield* _send(event);
    } else if (event is ChatReplyToEvent) {
      yield this.state.setReplyTo(event.message);
    }
  }

  Stream<ChatState> _send(ChatSendEvent event) async* {
    // add message to state
    Message message = this.state.replyTo != null
        ? event.message.copyWith(replyTo: this.state.replyTo)
        : event.message;
    List<Message> messages = [
      ...this.state.messages
    ]; // get a copy of messages list
    messages.add(message);
    yield this.state.setReplyTo(null, messages: messages);
    print("added message");

    if (message.type != MessageType.text && message.file != null) {
      // if we are sending a image or audio
      final uploadtask = Extras.uploadFile(message.file);
      await uploadtask.onComplete;
      final String fileUrl = await uploadtask.lastSnapshot.ref.getDownloadURL();
      message = message.copyWith(value: fileUrl);
      await Future.delayed(Duration(
          seconds: 3)); // wait for some seconds to simulate the response
      yield* _sendWitAI(message, completer: event.completer, checkUrl: false);
      return;
    }
    await Future.delayed(Duration(seconds: 3));
    yield* _sendWitAI(message,
        completer: event.completer, checkUrl: message.type == MessageType.text);
  }

  Stream<ChatState> _sendWitAI(Message message,
      {Completer<bool> completer, bool checkUrl = true}) async* {
    // send messato to witAI
    final responses = await _witAI.sendMessage(message.value);
    final messages = this.state.messages + responses;
    // chage message status to sending false
    final index = messages.indexWhere((item) => item.id == message.id);
    if (index != -1) {
      message = message.copyWith(sending: false);
      messages[index] = message;
    }
    yield this.state.copyWith(messages: messages); // update
    if (completer != null) {
      completer.complete(true);
    }

    if (checkUrl) {
      yield* _checkIfMessageIsUrl(message);
    }
  }

  Stream<ChatState> _checkIfMessageIsUrl(Message message) async* {
    // if the message sent was a link
    if (LinkPreview.hasUrl(message.value)) {
      //we get a link preview
      LinkPreview linkPreview =
          await LinkPreview.fetch(LinkPreview.getUrlFromString(message.value));
      if (linkPreview != null) {
        final index =
            this.state.messages.indexWhere((item) => item.id == message.id);
        if (index != -1) {
          List<Message> messages = [
            ...this.state.messages
          ]; // get a copy of messages list
          message = message.copyWith(linkPreview: linkPreview);
          messages = [...messages]; // get a copy of messages list
          messages[index] = message;
          yield this.state.copyWith(messages: messages);
        }
      }
    }
  }
}
