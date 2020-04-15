import 'dart:async';

import 'package:modernui/examples/deezer/models/track.dart';

abstract class DeezerEvents {}

class DeezerFetchEvent extends DeezerEvents {
  final String query;
  Completer<void> completer;

  DeezerFetchEvent(this.query);

  Future<void> init() async {
    completer = Completer();
    return completer.future;
  }
}

class DeezerAddToFavoritesEvent extends DeezerEvents {
  final DeezerTrack track;
  DeezerAddToFavoritesEvent(this.track);
}

class DeezerCurrentTrackEvent extends DeezerEvents {
  final  int index;
  DeezerCurrentTrackEvent(this.index);
}
