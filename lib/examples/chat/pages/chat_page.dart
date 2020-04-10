import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernui/examples/chat/bloc/chat_bloc.dart';
import 'package:modernui/examples/chat/bloc/chat_events.dart';
import 'package:modernui/examples/chat/bloc/chat_state.dart';
import 'package:modernui/examples/chat/widgets/message_item.dart';
import 'package:modernui/examples/chat/widgets/reply_to.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../widgets/chat_input.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatBloc _bloc = ChatBloc();
  GlobalKey<ChatInputState> _chatInputKey = GlobalKey<ChatInputState>();
  final _myUserId = "Darwin";

  final ItemScrollController _itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  _scrollToEnd() {
    if (_bloc.state.messages.length > 0) {
      _itemScrollController.scrollTo(
          index: _bloc.state.messages.length - 1,
          duration: Duration(milliseconds: 300));
    }
  }

  _searchMessageAndScroll(String messageId) {
    final int index =
        _bloc.state.messages.indexWhere((item) => item.id == messageId);

    if (index != -1) {
      // print("object key ${key != null} ");
      // Scrollable.ensureVisible(key.currentContext,
      //     duration: Duration(milliseconds: 300));
      _itemScrollController.scrollTo(
          index: index, duration: Duration(milliseconds: 300));
    }
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
                        return GestureDetector(
                          onTap: (){
                            print("t"); 
                          },
                          child: ScrollablePositionedList.builder(
                            itemCount: state.messages.length,
                            itemScrollController: _itemScrollController,
                            itemBuilder: (_, index) {
                              final message = state.messages[index];

                              return MessageItem(
                                onReply: () =>
                                    _bloc.add(ChatReplyToEvent(message)),
                                message: message,
                                myUserId: _myUserId,
                                goToRepy: message.replyTo != null
                                    ? () => _searchMessageAndScroll(
                                        message.replyTo.id)
                                    : null,
                              );
                            },
                          ),
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
