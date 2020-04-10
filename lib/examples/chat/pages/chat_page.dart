import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernui/examples/chat/bloc/chat_bloc.dart';
import 'package:modernui/examples/chat/bloc/chat_events.dart';
import 'package:modernui/examples/chat/bloc/chat_state.dart';
import 'package:modernui/examples/chat/widgets/message_item.dart';
import 'package:modernui/examples/chat/widgets/reply_to.dart';
import '../widgets/chat_input.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatBloc _bloc = ChatBloc();
  GlobalKey<ChatInputState> _chatInputKey = GlobalKey<ChatInputState>();
  final _myUserId = "Darwin";
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _bloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollToEnd() {
    Timer(Duration(milliseconds: 500), () {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) return;
      if (this.mounted) {
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 50,
            duration: Duration(seconds: 1),
            curve: Curves.linear);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            _chatInputKey.currentState?.dismissStickers();
          },
          child: Container(
            color: Colors.white,
            child: SafeArea(
                child: Column(
              children: <Widget>[
                Expanded(
                    child: Stack(
                  children: <Widget>[
                    BlocBuilder<ChatBloc, ChatState>(
                      builder: (_, state) {
                        return ListView.builder(
                          controller: _scrollController,
                          itemBuilder: (_, index) {
                            final message = state.messages[index];
                            return MessageItem(
                                onReply: () =>
                                    _bloc.add(ChatReplyToEvent(message)),
                                message: message,
                                myUserId: _myUserId);
                          },
                          itemCount: state.messages.length,
                        );
                      },
                      condition: (prevState, newState) =>
                          prevState.messages != newState.messages,
                    ),
                    ReplyTo(
                      myUserId: _myUserId,
                    )
                  ],
                )),
                ChatInput(
                  key: _chatInputKey,
                  userId: _myUserId,
                  onStickersOpen: () => _scrollToEnd(),
                  onSubmit: (message) async {
                    final event = ChatSendEvent(message);
                    _bloc.add(event);
                    _scrollToEnd(); // scroll to end of the list
                    await event.send(); //fater the message mas send
                    _scrollToEnd(); // scroll to end of the list
                  },
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}
