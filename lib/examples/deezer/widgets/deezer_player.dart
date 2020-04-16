import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flauto.dart';
import 'package:flutter_sound/track_player.dart';
import 'package:modernui/examples/deezer/models/track.dart';
import 'package:modernui/utils/config.dart';
import 'package:modernui/utils/extras.dart';

enum DeezerPlayerStatus { playing, paused, stopped, loading, loaded }

class DezzerPlayer extends StatefulWidget {
  final List<DeezerTrack> tracks;
  final VoidCallback onNext, onPrev;

  const DezzerPlayer(
      {Key key,
      @required this.tracks,
      @required this.onNext,
      @required this.onPrev})
      : assert(tracks != null),
        super(key: key);
  @override
  _DezzerPlayerState createState() => _DezzerPlayerState();
}

class _DezzerPlayerState extends State<DezzerPlayer> {
  ValueNotifier<int> _position = ValueNotifier(0);
  AudioPlayer _audioPlayer = AudioPlayer();
  DeezerPlayerStatus _status = DeezerPlayerStatus.loading;
  int _duration = 0;
  DeezerTrack _deezerTrack;
  Timer _timer;
  StreamSubscription _subs, _playerStateChangedSubs;
  int _index = 0;
  bool _sliderDragging = false;
  bool _autoplay;

  bool get _isPlayingOrPaused {
    return _status == DeezerPlayerStatus.playing ||
        _status == DeezerPlayerStatus.paused;
  }

  bool get _isPlaying {
    return _status == DeezerPlayerStatus.playing;
  }

  bool get _isPaused {
    return _status == DeezerPlayerStatus.paused;
  }

  bool get _isStopped {
    return _status == DeezerPlayerStatus.stopped;
  }

  bool get _isLoading {
    return _status == DeezerPlayerStatus.loading;
  }

  bool get _isLoaded {
    return _status == DeezerPlayerStatus.loaded;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    try {
      AudioPlayer.logEnabled = false;
      if (Platform.isIOS) {
        _audioPlayer.startHeadlessService();
      }
      _set(_index);
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _subs?.cancel();
    _playerStateChangedSubs?.cancel();
    _audioPlayer.release();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _set(int index) async {
    if (_isPlaying) {
      await _audioPlayer.stop();
    }
    await _subs?.cancel();
    _timer?.cancel();
    _deezerTrack = widget.tracks[_index];
    _status = DeezerPlayerStatus.loading;
    setState(() {});
    _position.value = 0;

    _subs = _audioPlayer
        .setUrl(_deezerTrack.preview)
        .asStream()
        .listen((result) async {
      if (result == 1) {
        _status = DeezerPlayerStatus.loaded;
        await _audioPlayer.setReleaseMode(
            ReleaseMode.STOP); // set release mode so that it never releases
        final duration = await _audioPlayer.getDuration();
        _duration = duration ~/ 1000;
        setState(() {});
        if (_autoplay != null && _autoplay) {
          _play();
        }
        _autoplay = null;
      }
    });
  }

  Future<void> _play() async {
    try {
      _playerStateChangedSubs?.cancel();
      print("play");
      int result = await _audioPlayer.resume();
      if (result == 1) {
        _audioPlayer.onNotificationPlayerStateChanged
            .listen(_onAudioPlayerState);

        _playerStateChangedSubs =
            _audioPlayer.onPlayerStateChanged.listen(_onAudioPlayerState);

        _status = DeezerPlayerStatus.playing;

        if (Platform.isIOS) {
          await _audioPlayer.setNotification(
              title: _deezerTrack.title,
              albumTitle: _deezerTrack.album.title,
              artist: _deezerTrack.artist.name,
              forwardSkipInterval: Duration(seconds: _duration),
              backwardSkipInterval: Duration(seconds: 0),
              imageUrl: _deezerTrack.album.cover);
        }

        setState(() {});
        _audioPlayer.onAudioPositionChanged.listen((position) {
          if (_duration > position.inSeconds && position.inSeconds == 0) {
            _prev();
            return;
          }
          if (!_sliderDragging && _isPlaying) {
            _position.value = position.inSeconds;
          }
        });
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  _onAudioPlayerState(AudioPlayerState state) {
    print(state);
    switch (state) {
      case AudioPlayerState.COMPLETED:
        _next();
        break;

      case AudioPlayerState.PAUSED:
        break;

      case AudioPlayerState.PLAYING:
        break;

      case AudioPlayerState.STOPPED:
        break;
    }
  }

  _next() async {
    if (_index < widget.tracks.length - 1) {
      _index++;
      widget.onNext();
      if (_autoplay == null) {
        _autoplay = _isPlaying;
      }
      _set(_index);
    } else {
      await _stop();
    }
  }

  _prev() async {
    if (_position.value > 2) {
      _position.value = 0;
      await _audioPlayer.seek(Duration(seconds: 0));
      return;
    }

    if (_index > 0) {
      _index--;
      widget.onPrev();
      if (_autoplay == null) {
        _autoplay = _isPlaying;
      }
      _set(_index);
    } else {
      await _stop();
    }
  }

  Future<void> _stop() async {
    if (_isPlayingOrPaused) {
      _position.value = 0;
      _status = DeezerPlayerStatus.stopped;
      final result = await _audioPlayer.stop();
      if (result == 1) {
        setState(() {});
      }
    }
  }

  Future<void> _pause() async {
    if (_isPlaying) {
      int result = await _audioPlayer.pause();
      if (result == 1) {
        _status = DeezerPlayerStatus.paused;
        setState(() {});
      }
    }
  }

  Future<void> _resume() async {
    if (_isPaused) {
      int result = await _audioPlayer.resume();
      if (result == 1) {
        _status = DeezerPlayerStatus.playing;
        setState(() {});
      }
    }
  }

  Future<void> _onPlayPause() async {
    if (_isPlaying) {
      await _pause();
    } else if (_isPaused) {
      await _resume();
    } else {
      await _play();
    }
  }

  Widget _getPlayPauseButton() {
    if (_isLoading) {
      return CupertinoActivityIndicator();
    }
    return Icon(
      _isPlaying ? Icons.pause : Icons.play_arrow,
      size: 40,
      color: AppColors.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.skip_previous,
                  size: 45,
                  color: AppColors.primary,
                ),
                onPressed: _prev,
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 3,
                      color: Color(0xffd2d2d2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                  child: _getPlayPauseButton(),
                ),
                onPressed: _isLoading ? null : _onPlayPause,
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.skip_next,
                  size: 45,
                  color: AppColors.primary,
                ),
                onPressed: _next,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              ValueListenableBuilder(
                valueListenable: _position,
                builder: (_, int position, w) {
                  return Text(Extras.getTime(position));
                },
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _position,
                  builder: (_, int position, __) {
                    final double value =
                        _duration > 0 ? ((position / _duration) * 100) : 0;

                    return AbsorbPointer(
                      absorbing: _status == DeezerPlayerStatus.loading,
                      child: Slider(
                        value: value > 100 ? 100 : value,
                        label: "${Extras.getTime(position)}",
                        divisions: 100,
                        min: 0,
                        max: 100,
                        activeColor: AppColors.primary,
                        inactiveColor: Color(0xffdddddd),
                        onChangeEnd: (_) async {
                          final seekTo = _duration * _ ~/ 100; // in seconds
                          if (_isPlayingOrPaused) {
                            int result = await _audioPlayer
                                .seek(Duration(seconds: seekTo));
                            _sliderDragging = false;
                          }
                        },
                        onChangeStart: (_) {
                          _sliderDragging = true;
                        },
                        onChanged: (_) {
                          _position.value = _duration * _ ~/ 100;
                        },
                      ),
                    );
                  },
                ),
              ),
              Text(
                _duration == 0 ? '--:--' : Extras.getTime(_duration),
              ),
            ],
          )
        ],
      ),
    );
  }
}
