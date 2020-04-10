import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modernui/examples/chat/models/message.dart';
import 'package:modernui/examples/chat/widgets/draggable_record.dart';
import 'package:modernui/utils/extras.dart';
import 'package:modernui/utils/responsive.dart';
import 'package:permission_handler/permission_handler.dart';

import 'chat_icon_button.dart';
import 'chat_missing_permission.dart';
import 'stickers_picker.dart';

class ChatInput extends StatefulWidget {
  final String userId;
  final void Function(Message) onSubmit;
  final VoidCallback onStickersOpen;

  const ChatInput(
      {Key key,
      @required this.onSubmit,
      @required this.userId,
      @required this.onStickersOpen})
      : assert(onSubmit != null && userId != null && onStickersOpen != null),
        super(key: key);
  @override
  ChatInputState createState() => ChatInputState();
}

class ChatInputState extends State<ChatInput> {
  String _text = "";
  ValueNotifier<bool> _inputHasFocus = ValueNotifier<bool>(false);

  ValueNotifier<Permission> _permission = ValueNotifier<Permission>(null);
  ValueNotifier<bool> _recording = ValueNotifier<bool>(false);
  ValueNotifier<bool> _stickersEnabled = ValueNotifier<bool>(false);
  TextEditingController _editingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  Widget get _buttons {
    return Row(
      children: <Widget>[
        ChatIconButton(
          iconPath: 'assets/chat/camera.svg',
          onPressed: () async {
            dismissStickers();
            final isOk = await _checkPermission(Permission.camera);
            if (isOk) {
              final file =
                  await Extras.pickImage(fromCamera: true, withCompress: true);
              if (file != null) _send(file.path, MessageType.image, file: file);
            } else {
              _permission.value = Permission.camera;
            }
          },
        ),
        SizedBox(width: 10),
        ChatIconButton(
          iconPath: 'assets/chat/photo.svg',
          onPressed: () async {
            dismissStickers();
            final isOk = await _checkPermission(Permission.photos);
            if (isOk) {
              final file =
                  await Extras.pickImage(fromCamera: false, withCompress: true);

              if (file != null) _send(file.path, MessageType.image, file: file);
            } else {
              _permission.value = Permission.photos;
            }
          },
        ),
        SizedBox(width: 10),
        ChatIconButton(
          iconPath: 'assets/chat/joke.svg',
          onPressed: () {
            _stickersEnabled.value = !_stickersEnabled.value;
            if (_stickersEnabled.value) {
              widget.onStickersOpen();
            }
            _focusNode.unfocus();
          },
        ),
      ],
    );
  }

  void dismissStickers() {
    _stickersEnabled.value = false;
  }

  void _removeInputFocus() {
    _focusNode.unfocus();
  }

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          _removeInputFocus();
        }
      },
    );

    _focusNode.addListener(() {
      _inputHasFocus.value = _focusNode.hasFocus;
      if (_focusNode.hasFocus && _stickersEnabled.value) {
        dismissStickers();
      }
    });
  }

  @override
  void dispose() {
    _editingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get _permissionName {
    return _permission.value.toString().replaceFirst("Permission.", "");
  }

  Future<bool> _checkPermission(Permission permission) async {
    return await permission.isGranted;
  }

  void _send(String value, String type, {File file}) {
    final message = Message(
        userId: widget.userId,
        sending: true,
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: type,
        file: file,
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
            alignment: Alignment.centerLeft,
            children: <Widget>[
              SizedBox(
                  height: 50,
                  width: double
                      .infinity), // WE NEED DEFIEND  A MIN SIZE FOR THE STACK

              // START SEND BUTTON
              Positioned(
                right: 0,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: 25,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff2979FF),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: SvgPicture.asset(
                      'assets/chat/send.svg',
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (_text.trim().length == 0) return; // if text is empty
                    _send(_text, MessageType.text);
                    _text = "";
                    _editingController.text = "";
                  },
                ),
              ),
              // SEND SEND BUTTON

              // START DRAGGABLE RECORD
              ValueListenableBuilder(
                valueListenable: _inputHasFocus,
                builder: (_, bool isValidText, child) {
                  return AnimatedSwitcher(
                    child: isValidText ? Container() : child,
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    duration: Duration(milliseconds: 300),
                  );
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
                    _send(
                      path,
                      MessageType.audio,
                      file: File(path),
                    );
                  },
                ),
              ),
              // END DRAGGABLE RECORD

              //START INPUT TEXT
              ValueListenableBuilder(
                valueListenable: _recording,
                builder: (_, bool isRecording, child) {
                  return AnimatedPositioned(
                    left: isRecording ? -inputWidth : 0,
                    child: child,
                    duration: Duration(milliseconds: 300),
                  );
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
                          focusNode: _focusNode,
                          onChanged: (text) {
                            this._text = text;
                          },
                          decoration: BoxDecoration(color: Colors.transparent),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _inputHasFocus,
                        builder: (_, bool hasFocus, child) {
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
                            child: hasFocus
                                ? ChatIconButton(
                                    iconPath: 'assets/down-arrow.svg',
                                    onPressed: _removeInputFocus,
                                  )
                                : _buttons,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // END INPUT TEXT
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _permission,
          builder: (_, Permission permission, child) {
            final isCameraPermission = _permissionName == 'camera';
            if (permission == null) return Container();
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              transitionBuilder: (Widget _, animation) => SizeTransition(
                sizeFactor: animation,
                child: _,
              ),
              child: permission == null
                  ? Container()
                  : ChatMissingPermission(
                      permission: permission,
                      title: "JUST ONE STEP",
                      description: isCameraPermission
                          ? "To take and send photos we need access to your camera"
                          : "To send images we need access to your photos",
                      onGranted: () {
                        _permission.value = null;
                      },
                    ),
            );
          },
        ),
        ValueListenableBuilder(
            valueListenable: _stickersEnabled,
            builder: (_, bool enabled, child) {
              return AnimatedSwitcher(
                transitionBuilder: (_, animation) =>
                    SizeTransition(sizeFactor: animation, child: _),
                duration: Duration(milliseconds: 300),
                child: enabled
                    ? StickersPicker(
                        onPicked: (imageurl) =>
                            _send(imageurl, MessageType.image),
                      )
                    : Container(),
              );
            })
      ],
    );
  }
}
