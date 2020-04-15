import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flauto.dart';
import 'package:flutter_sound/track_player.dart';
import 'package:modernui/examples/deezer/models/track.dart';
import 'package:modernui/utils/config.dart';
import 'package:modernui/utils/extras.dart';

enum DezzerPlayerStatus { playing, paused, stop }

class DezzerPlayer extends StatefulWidget {
  final DeezerTrack deezerTrack;

  final VoidCallback onNext, onPrev;

  const DezzerPlayer(
      {Key key,
      @required this.deezerTrack,
      @required this.onNext,
      @required this.onPrev})
      : assert(deezerTrack != null),
        super(key: key);
  @override
  _DezzerPlayerState createState() => _DezzerPlayerState();
}

class _DezzerPlayerState extends State<DezzerPlayer> {
  ValueNotifier<int> _position = ValueNotifier(0);
  TrackPlayer _trackPlayer;
  DezzerPlayerStatus _status = DezzerPlayerStatus.stop;
  int _duration = 0;
  StreamSubscription _subs;
  StreamSubscription _buildSubs;
  DeezerTrack _deezerTrack;

  bool _sliderDragging = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    try {
      _buildSubs = _builTrack().asStream().listen((_) {});
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

  @override
  void didUpdateWidget(DezzerPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("got to ${widget.deezerTrack.id}");
    if (oldWidget.deezerTrack.id != widget.deezerTrack.id) {
      _buildSubs?.cancel();
      _buildSubs = _builTrack().asStream().listen((_) {
        _play();
      });
    }
  }

  Future<void> _builTrack() async {
    _deezerTrack = widget.deezerTrack;
    await _stop();
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

      await _trackPlayer.startPlayerFromTrack(
        track,
        whenFinished: () async {
          await this._stop();
          setState(() {});
          widget.onNext();
        },
        onSkipBackward: _prev,
        onSkipForward: _next,
      );
      _subs = _trackPlayer.onPlayerStateChanged.listen((status) {
        final position = status.currentPosition ~/ 1000; // in seconds
        if (!_sliderDragging) {
          _position.value = position;
        }
      });
      _status = DezzerPlayerStatus.playing;
      setState(() {});
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  _next() async {
    await _stop();
    widget.onNext();
    setState(() {});
  }

  _prev() async {
    await _stop();
    widget.onPrev();
    setState(() {});
  }

  Future<void> _stop() async {
    _status = DezzerPlayerStatus.stop;
    await _subs?.cancel();
    await _trackPlayer?.stopPlayer();
    _position.value = 0;
  }

  Future<void> _pause() async {
    if (_trackPlayer.isPlaying) {
      await _trackPlayer.pausePlayer();
      _status = DezzerPlayerStatus.paused;
      setState(() {});
    }
  }

  Future<void> _resume() async {
    if (_trackPlayer.isPaused) {
      await _trackPlayer.resumePlayer();
      _status = DezzerPlayerStatus.playing;
      setState(() {});
    }
  }

  Future<void> _onPlayPause() async {
    if (_status == DezzerPlayerStatus.playing) {
      await _pause();
    } else if (_status == DezzerPlayerStatus.paused) {
      await _resume();
    } else {
      await _play();
    }
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
                  child: Icon(
                    _status == DezzerPlayerStatus.playing
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                onPressed: _onPlayPause,
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

                    return Slider(
                      value: value > 100 ? 100 : value,
                      label: "${Extras.getTime(position)}",
                      divisions: 100,
                      min: 0,
                      max: 100,
                      activeColor: AppColors.primary,
                      inactiveColor: Color(0xffdddddd),
                      onChangeEnd: (_) async {
                        final seekTo = _duration * _ ~/ 100; // in seconds
                        await _trackPlayer.seekToPlayer(seekTo * 1000);
                        _sliderDragging = false;
                      },
                      onChangeStart: (_) {
                        _sliderDragging = true;
                      },
                      onChanged: (_) {
                        _position.value = _duration * _ ~/ 100;
                      },
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
