import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flauto.dart';
import 'package:flutter_sound/track_player.dart';
import 'package:modernui/examples/deezer/models/track.dart';
import 'package:modernui/utils/config.dart';
import 'package:modernui/utils/extras.dart';

enum DeezerPlayerStatus { playing, paused, stop, loading }

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
  TrackPlayer _trackPlayer;
  DeezerPlayerStatus _status = DeezerPlayerStatus.loading;
  int _duration = 0;
  StreamSubscription _subs;
  StreamSubscription _buildSubs;
  DeezerTrack _deezerTrack;

  int _index = 0;

  bool _sliderDragging = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    try {
      _buildSubs = _builTrack(_index).asStream().listen((_) {});
      _trackPlayer = TrackPlayer();
      await _trackPlayer.initialize();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _trackPlayer?.release();
    _subs?.cancel();
    _buildSubs?.cancel();
    super.dispose();
  }

  Future<void> _builTrack(int index) async {
    _deezerTrack = widget.tracks[index];
    if (_trackPlayer != null && !_trackPlayer.isStopped) {
      await _stop();
    }
    await _getDuration();
  }

  _getDuration() async {
    final duration = await FlutterSoundHelper().duration(_deezerTrack.preview);
    //FlutterSoundHelper().FFmpegGetMediaInformation(uri).
    _duration = duration ~/ 1000;
    setState(() {});
  }

  Future<void> _play() async {
    try {
      // Create with the path to the audio file
      Track track = new Track(
        trackPath: _deezerTrack.preview, // An example audio file
        trackTitle: _deezerTrack.title,
        trackAuthor: _deezerTrack.artist.name,
        albumArtUrl: _deezerTrack.album.cover, // An example image
      );
      _status = DeezerPlayerStatus.loading;
      _position.value = 0;
      setState(() {});
      await _trackPlayer
          .startPlayerFromTrack(
        track,
        whenFinished: () async {
          _next();
        },
        onSkipBackward: _prev,
        onSkipForward: _next,
        whenPaused: (_) {
          if (_status == DeezerPlayerStatus.paused) {
            _resume();
          } else {
            _pause();
          }
        },
      )
          .whenComplete(() {
        _status = DeezerPlayerStatus.playing;
        setState(() {});
      });
      //_trackPlayer.setSubscriptionDuration(1);
      _subs = _trackPlayer.onPlayerStateChanged.listen((status) {
        final position = status.currentPosition ~/ 1000; // in seconds
        if (!_sliderDragging && _status != DeezerPlayerStatus.loading) {
          _position.value = position;
        }
      });
      _status = DeezerPlayerStatus.playing;
      setState(() {});
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  _next() async {
    await _buildSubs?.cancel();
    if (_index < widget.tracks.length) {
      _index++;
      _buildSubs = _builTrack(_index).asStream().listen((_) {
        _play();
        setState(() {});
      });
      widget.onNext();
    } else {
      await _stop();
      setState(() {});
    }
  }

  _prev() async {
    if (_position.value > 2) {
      await _trackPlayer?.seekToPlayer(0);
      _position.value = 0;
      return;
    }
    await _buildSubs?.cancel();
    if (_index > 0) {
      _index--;
      _buildSubs = _builTrack(_index).asStream().listen((_) {
        _play();
        setState(() {});
      });
      widget.onPrev();
    } else {
      await _stop();
      setState(() {});
    }
  }

  Future<void> _stop() async {
    _position.value = 0;
    _status = DeezerPlayerStatus.stop;
    await _subs?.cancel();
    await _trackPlayer?.stopPlayer();
  }

  Future<void> _pause() async {
    if (_trackPlayer.isPlaying) {
      await _trackPlayer.pausePlayer();
      _status = DeezerPlayerStatus.paused;
      setState(() {});
    }
  }

  Future<void> _resume() async {
    if (_trackPlayer.isPaused) {
      await _trackPlayer.resumePlayer();
      _status = DeezerPlayerStatus.playing;
      setState(() {});
    }
  }

  Future<void> _onPlayPause() async {
    if (_status == DeezerPlayerStatus.playing) {
      await _pause();
    } else if (_status == DeezerPlayerStatus.paused) {
      await _resume();
    } else {
      await _play();
    }
  }

  Widget _getPlayPauseButton() {
    if (_status == DeezerPlayerStatus.loading) {
      return CupertinoActivityIndicator();
    }
    return Icon(
      _status == DeezerPlayerStatus.playing ? Icons.pause : Icons.play_arrow,
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
                onPressed:
                    _status == DeezerPlayerStatus.loading ? null : _onPlayPause,
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
                          if (_trackPlayer.isPlaying || _trackPlayer.isPaused) {
                            await _trackPlayer?.seekToPlayer(seekTo * 1000);
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
