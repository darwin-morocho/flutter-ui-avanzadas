import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modernui/examples/chat/models/message.dart';
import 'package:modernui/examples/chat/widgets/draggable_record.dart';
import 'package:modernui/utils/responsive.dart';
import 'package:modernui/widgets/rounded_button.dart';
import 'package:permission_handler/permission_handler.dart';

import 'chat_icon_button.dart';
import 'chat_missing_permission.dart';

class ChatInput extends StatefulWidget {
  final String userId;
  final void Function(Message) onSubmit;

  const ChatInput({Key key, @required this.onSubmit, @required this.userId})
      : assert(onSubmit != null && userId != null),
        super(key: key);
  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  String _text = "";
  ValueNotifier<bool> _isValidText = ValueNotifier<bool>(false);
  ValueNotifier<Widget> _inputButtons;

  ValueNotifier<bool> _recording = ValueNotifier<bool>(false);
  TextEditingController _editingController = TextEditingController();

  Widget get _buttons {
    return Row(
      children: <Widget>[
        ChatIconButton(iconPath: 'assets/chat/photo.svg', onPressed: () {}),
        SizedBox(width: 10),
        ChatIconButton(iconPath: 'assets/chat/joke.svg', onPressed: () {}),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _inputButtons = ValueNotifier<Widget>(_buttons);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  void _send(String value, String type) {
    final message = Message(
        userId: widget.userId,
        sending: true,
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: type,
        value: value);
    widget.onSubmit(message);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.init(context);
    final inputWidth = responsive.width - 75;

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              SizedBox(
                  height: 50,
                  width: double
                      .infinity), // WE NEED DEFIEND  A MIN SIZE FOR THE STACK

              // START SEND BUTTON
              Positioned(
                right: 0,
                top: 5,
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 25,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xff2979FF),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: SvgPicture.asset(
                        'assets/chat/send.svg',
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      _send(_text, MessageType.text);
                      _text = "";
                      _editingController.text = "";
                      _isValidText.value = false;
                      _inputButtons.value = _buttons;
                    }),
              ),
              // SEND SEND BUTTON

              // START DRAGGABLE RECORD
              ValueListenableBuilder(
                valueListenable: _isValidText,
                builder:
                    (BuildContext context, bool isValidText, Widget child) {
                  return AnimatedSwitcher(
                      child: isValidText ? Container() : child,
                      transitionBuilder: (child, animation) {
                        return SizeTransition(
                          axis: Axis.horizontal,
                          sizeFactor: animation,
                          axisAlignment: 1,
                          child: child,
                        );
                      },
                      duration: Duration(milliseconds: 600));
                },
                child: DraggableRecord(
                  onCancel: () {
                    print("cancel recording");
                    _recording.value = false;
                  },
                  onStart: () {
                    print("start recording");
                    _recording.value = true;
                  },
                  onRecorded: (path) {
                    print("record $path");
                    _recording.value = false;
                    widget.onSubmit(Message(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        userId: widget.userId,
                        value: path,
                        type: MessageType.audio,
                        sending: true));
                  },
                ),
              ),
              // END DRAGGABLE RECORD

              //START INPUT TEXT
              ValueListenableBuilder(
                valueListenable: _recording,
                builder:
                    (BuildContext context, bool isRecording, Widget child) {
                  return AnimatedSwitcher(
                      child: !isRecording
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: child,
                            )
                          : Container(),
                      duration: Duration(milliseconds: 300));
                },
                child: Container(
                  width: inputWidth,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                      color: Color(0xfff0f0f0),
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: CupertinoTextField(
                        controller: _editingController,
                        placeholder: "Your message here ...",
                        maxLines: null,
                        onChanged: (text) {
                          this._text = text;
                          final isValid = _text.trim().length > 0;
                          if (_isValidText.value != isValid) {
                            _isValidText.value = isValid;
                            _inputButtons.value =
                                isValid ? Container() : _buttons;
                          }
                        },
                        decoration: BoxDecoration(color: Colors.transparent),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      )),
                      ValueListenableBuilder(
                        valueListenable: _inputButtons,
                        builder:
                            (BuildContext context, Widget value, Widget child) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return SizeTransition(
                                axis: Axis.horizontal,
                                sizeFactor: animation,
                                axisAlignment: -1,
                                child: child,
                              );
                            },
                            child: _inputButtons.value,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //END INPUT TEXT
            ],
          ),
        ),
      ],
    );
  }
}
