import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernui/examples/chat/bloc/chat_bloc.dart';
import 'package:modernui/examples/chat/bloc/chat_events.dart';
import 'package:modernui/examples/chat/bloc/chat_state.dart';
import 'package:modernui/examples/chat/widgets/message_view.dart';

class ReplyTo extends StatelessWidget {
  final String myUserId;

  const ReplyTo({Key key, @required this.myUserId})
      : assert(myUserId != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ChatBloc>(context);
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (_, state) {
        if (state.replyTo == null) return Container();
        return Positioned(
          left: 10,
          right: 10,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(
                    color: myUserId == state.replyTo.userId
                        ? Color(0xff2979FF)
                        : Color(0xffdddddd),
                    width: 5),
              ),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Respondiendo a:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      SizedBox(height: 3),
                      MessageView(
                        message: state.replyTo,
                        myUserId: null,
                        isInsideReplyTo: true,
                      )
                    ],
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.all(0),
                  minSize: 20,
                  child: Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.red,
                  ),
                  onPressed: () => bloc.add(
                    ChatReplyToEvent(null),
                  ),
                )
              ],
            ),
          ),
        );
      },
      condition: (prevState, newState) => prevState.replyTo != newState.replyTo,
    );
  }
}
