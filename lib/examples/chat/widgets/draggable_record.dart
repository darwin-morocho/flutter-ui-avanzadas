import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modernui/utils/config.dart';
import 'package:modernui/utils/extras.dart';
import 'package:modernui/utils/responsive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import 'chat_missing_permission.dart';
import 'draggable_icon.dart';

enum RecordPermissionStatus { granted, denied, needsRequest }

class DraggableRecord extends StatefulWidget {
  final VoidCallback onStart, onCancel;
  final void Function(String) onRecorded;

  const DraggableRecord(
      {Key key,
      @required this.onStart,
      @required this.onCancel,
      @required this.onRecorded})
      : assert(onCancel != null && onStart != null && onRecorded != null),
        super(key: key);
  @override
  _DraggableRecordState createState() => _DraggableRecordState();
}

class _DraggableRecordState extends State<DraggableRecord> {
  FlutterSoundRecorder _recorder;
  StreamSubscription _recorderSubs;
  String _path;
  ValueNotifier<bool> _dragUnderway = ValueNotifier<bool>(false);
  ValueNotifier<RecordPermissionStatus> _permissionStatus =
      ValueNotifier<RecordPermissionStatus>(RecordPermissionStatus.denied);
  ValueNotifier<int> _recordingTime = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _release();
    _recorderSubs?.cancel();
  }

  Future<void> _release() async {
    try {
      await _recorder?.release();
      _recorder = null;
    } catch (e) {
      print('Released unsuccessful');
      print(e);
    }
  }

  _init() async {
    try {
      final bool isGranted = await Permission.microphone.isGranted;
      if (isGranted) {
        _permissionStatus.value = RecordPermissionStatus.granted;
      }
    } catch (e) {
      print(e);
    }
  }

  _startRecording() async {
    _recorder = await FlutterSoundRecorder().initialize();
    Directory tempDir = await getTemporaryDirectory();
    File outputFile =
        File('${tempDir.path}/${DateTime.now().microsecondsSinceEpoch}.aac');
    _path = await _recorder.startRecorder(uri: outputFile.path);
    _recorderSubs =
        _recorder.onRecorderStateChanged.listen((RecordStatus status) {
      //print(status);
      final recordingTime = status.currentPosition ~/ 1000;
      if (recordingTime != _recordingTime.value) {
        _recordingTime.value = recordingTime;
      }
    });
    _dragUnderway.value = true;
    widget.onStart();
  }

  _stopRecording() async {
    _dragUnderway.value = false;
    await _recorderSubs?.cancel();
    await _release();
    _recorder = null;
    if (_path != null && _recordingTime.value > 1) {
      widget.onRecorded(_path);
    } else if (_permissionStatus.value == RecordPermissionStatus.granted) {
      widget.onCancel();
    }
    _recordingTime.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.init(context);

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 50,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ValueListenableBuilder(
                valueListenable: _dragUnderway,
                builder: (BuildContext context, bool value, Widget child) {
                  return AnimatedOpacity(
                    opacity: value ? 1 : 0,
                    duration: Duration(milliseconds: 400),
                    child: child,
                  );
                },
                child: Shimmer.fromColors(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Swipe to cancel",
                          style: TextStyle(
                              fontSize: 18,
                              color: Color(0xffaaaaaa),
                              fontFamily: 'sans'),
                        ),
                        SizedBox(width: 10),
                        SvgPicture.asset('assets/chat/three_arrow.svg',
                            width: 15, color: Color(0xffaaaaaa))
                      ],
                    ),
                    baseColor: Color(0xffaaaaaa),
                    highlightColor: Colors.black),
              ),
              Positioned(
                left: 0,
                child: DragTarget<String>(
                  builder: (_, candidates, rejects) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        DraggableIcon(
                          iconPath: candidates.length > 0
                              ? 'assets/chat/trash.svg'
                              : 'assets/chat/dot.svg',
                          color: Colors.redAccent,
                          backgroundColor: Colors.transparent,
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(right: responsive.width * 0.3),
                          child: ValueListenableBuilder(
                            valueListenable: _recordingTime,
                            builder: (BuildContext context, int value,
                                Widget child) {
                              return Text(
                                Extras.getTime(value),
                                style: TextStyle(fontSize: 17),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  },
                  onWillAccept: (_) {
                    // print("WillAccept $_");
                    return true;
                  },
                  onLeave: (_) {
                    // print("onLeave $_");
                  },
                  onAccept: (_) {
                    // print("accepted $_");
                    _path = null;
                  },
                ),
              ),
              Positioned(
                right: 0,
                child: Listener(
                  onPointerUp: (_) {
                    //print("onPointerUp");
                    _stopRecording();
                  },
                  onPointerDown: (_) {
                    // print("onPointerDown");
                    if (_permissionStatus.value ==
                        RecordPermissionStatus.granted) {
                      _startRecording();
                    } else if (_permissionStatus.value ==
                        RecordPermissionStatus.denied) {
                      _permissionStatus.value =
                          RecordPermissionStatus.needsRequest;
                    } else {
                      _permissionStatus.value = RecordPermissionStatus.denied;
                    }
                  },
                  child: ValueListenableBuilder(
                    valueListenable: _permissionStatus,
                    builder: (BuildContext context,
                        RecordPermissionStatus status, Widget child) {
                      if (status == RecordPermissionStatus.granted)
                        return child;
                      if (status == RecordPermissionStatus.needsRequest) {
                        return DraggableIcon(
                            iconPath: 'assets/cancel.svg',
                            color: Colors.redAccent);
                      }

                      return DraggableIcon(
                          iconPath: 'assets/chat/microphone.svg',
                          color: Colors.black);
                    },
                    child: Draggable<String>(
                        axis: Axis.horizontal,
                        data: "delete",
                        child: DraggableIcon(
                            iconPath: 'assets/chat/microphone.svg',
                            color: Colors.black),
                        childWhenDragging: DraggableIcon(
                            iconPath: 'assets/chat/microphone.svg',
                            color: Colors.black.withOpacity(0.3)),
                        feedback: DraggableIcon(
                            iconPath: 'assets/chat/microphone.svg',
                            color: AppColors.primary)),
                  ),
                ),
              ),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _permissionStatus,
          builder: (BuildContext context, RecordPermissionStatus status,
              Widget child) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (_, animation) {
                return SizeTransition(sizeFactor: animation, child: _);
              },
              child: status == RecordPermissionStatus.needsRequest
                  ? ChatMissingPermission(
                      permission: Permission.microphone,
                      onGranted: () {
                        _permissionStatus.value =
                            RecordPermissionStatus.granted;
                      },
                      description:
                          "To send audio files we need access to your microphone",
                    )
                  : Container(),
            );
          },
        ),
      ],
    );
  }
}
