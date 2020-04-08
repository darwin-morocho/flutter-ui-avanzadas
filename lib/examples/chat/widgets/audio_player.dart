import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound_player.dart';
import 'package:modernui/utils/config.dart';
import 'package:modernui/utils/extras.dart';

enum AudioPlayerStatus { playing, none, paused }

class AudioPlayer extends StatefulWidget {
  final String fileUri;

  const AudioPlayer({Key key, @required this.fileUri})
      : assert(fileUri != null),
        super(key: key);
  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  FlutterSoundPlayer _player;
  StreamSubscription _playerSubs;
  int _time = 0, _duration;
  AudioPlayerStatus _status = AudioPlayerStatus.none;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _playerSubs?.cancel();
    _player?.release();

    super.dispose();
  }

  _init() async {
    _player = await FlutterSoundPlayer().initialize();
  }

  _play() async {
    await _player?.startPlayer(widget.fileUri, whenFinished: () {
      //when finished
      _status = AudioPlayerStatus.none;
      _playerSubs?.cancel();
      _time = 0;
      setState(() {});
    });

    setState(() {
      _status = AudioPlayerStatus.playing;
    });

    _playerSubs = _player.onPlayerStateChanged.listen((status) {
      // audio duration in milliseconds to seconds
      final duration = status.duration ~/ 1000;

      // playing time in milliseconds to seconds
      _time = status.currentPosition ~/ 1000;
      if (_duration == null) {
        _duration = duration;
      }
      setState(() {});
    });
  }

  _stop() async {
    await _playerSubs?.cancel();
    await _player?.stopPlayer();
    _status = AudioPlayerStatus.none;
    _time = 0;
    setState(() {});
  }

  _pause() async {
    await _player?.pausePlayer();
    _status = AudioPlayerStatus.paused;
    setState(() {});
  }

  _resume() async {
    await _player?.resumePlayer();
    _status = AudioPlayerStatus.playing;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CupertinoButton(
          child: Icon(
            _status == AudioPlayerStatus.playing
                ? Icons.pause
                : Icons.play_arrow,
            color: AppColors.primary,
          ),
          minSize: 25,
          onPressed: () {
            if (_status == AudioPlayerStatus.none) {
              _play();
            } else if (_status == AudioPlayerStatus.playing) {
              _pause();
            } else if (_status == AudioPlayerStatus.paused) {
              _resume();
            }
          },
          padding: EdgeInsets.all(5),
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        SizedBox(width: 10),
        Text(
          "${Extras.getTime(_time)} / ${_duration!=null?Extras.getTime(_duration):"--:--"}",
          style: TextStyle(
              fontSize: 17, fontFamily: 'sans', color: Colors.white),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
