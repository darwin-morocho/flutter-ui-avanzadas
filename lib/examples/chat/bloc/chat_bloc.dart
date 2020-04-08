import 'package:bloc/bloc.dart';
import 'package:modernui/examples/chat/api/witai.dart';
import 'package:modernui/examples/chat/models/link_preview.dart';
import 'package:modernui/examples/chat/models/message.dart';
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

    // send messato to witAI
    await Future.delayed(Duration(seconds: 2)); // await for 2 seconds
    final responses = await _witAI.sendMessage(message.value);
    messages = this.state.messages + responses;
    // chage message status to sending false
    final index = messages.indexWhere((item) => item.id == message.id);
    if (index != -1) {
      message = message.copyWith(sending: false);
      messages[index] = message;
    }
    yield this.state.copyWith(messages: messages); // update
    event.completer.complete(true);

    yield* _checkIfMessageIsUrl(message);
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
