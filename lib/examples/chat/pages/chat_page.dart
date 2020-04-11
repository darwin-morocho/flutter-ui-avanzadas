import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modernui/examples/chat/bloc/chat_bloc.dart';
import 'package:modernui/examples/chat/bloc/chat_events.dart';
import 'package:modernui/examples/chat/bloc/chat_state.dart';
import 'package:modernui/examples/chat/widgets/chat_app_bar.dart';
import 'package:modernui/examples/chat/widgets/message_item.dart';
import 'package:modernui/examples/chat/widgets/reply_to.dart';
import 'package:modernui/utils/config.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../widgets/chat_input.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatBloc _bloc = ChatBloc();
  GlobalKey<InnerDrawerState> _drawerKey = GlobalKey<InnerDrawerState>();
  GlobalKey<ChatInputState> _chatInputKey = GlobalKey<ChatInputState>();
  final _myUserId = "Darwin";

  final ItemScrollController _itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
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
          duration: Duration(milliseconds: 500),
          curve: Curves.linear);
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
          index: index,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: InnerDrawer(
        key: _drawerKey,
        onTapClose: true, // default false
        rightChild: Container(
          color: Colors.white,
        ),
        scaffold: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              _chatInputKey.currentState?.dismissStickers();
            },
            child: Container(
              color: Colors.white,
              height: double.infinity,
              child: SafeArea(
                top: false,
                child: Column(
                  children: <Widget>[
                    ChatAppBar(
                      onOpenDrawer: () => _drawerKey.currentState.open(),
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          BlocBuilder<ChatBloc, ChatState>(
                            builder: (_, state) {
                              return ScrollablePositionedList.builder(
                                itemCount: state.messages.length,
                                itemScrollController: _itemScrollController,
                                itemBuilder: (_, index) {
                                  final message = state.messages[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: index == 0 ? 10 : 0),
                                    child: MessageItem(
                                      onReply: () =>
                                          _bloc.add(ChatReplyToEvent(message)),
                                      message: message,
                                      myUserId: _myUserId,
                                      goToRepy: message.replyTo != null
                                          ? () => _searchMessageAndScroll(
                                              message.replyTo.id)
                                          : null,
                                    ),
                                  );
                                },
                              );
                            },
                            condition: (prevState, newState) =>
                                prevState.messages != newState.messages,
                          ),
                          ReplyTo(
                            myUserId: _myUserId,
                          )
                        ],
                      ),
                    ),
                    ChatInput(
                      key: _chatInputKey,
                      userId: _myUserId,
                      onStickersOpen: () {},
                      onSubmit: (message) async {
                        final event = ChatSendEvent(message);
                        _bloc.add(event);
                        _scrollToEnd(); // scroll to end of the list
                        await event.send(); //fater the message mas send
                        _scrollToEnd(); // scroll to end of the list
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
