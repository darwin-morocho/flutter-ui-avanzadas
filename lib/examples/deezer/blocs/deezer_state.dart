import 'package:equatable/equatable.dart';
import 'package:modernui/examples/deezer/models/track.dart';

class DeezerState extends Equatable {
  final bool fetching;
  final List<DeezerTrack> tracks;
  final List<DeezerTrack> favorites;
  final int trackIndex;

  DeezerState(
      {this.fetching = true,
      this.tracks = const [],
      this.favorites = const [],
      this.trackIndex = 0});

  DeezerState copyWith({
    bool fetching,
    List<DeezerTrack> tracks,
    List<DeezerTrack> favorites,
    int trackIndex,
  }) {
    return DeezerState(
      fetching: fetching ?? this.fetching,
      tracks: tracks ?? this.tracks,
      favorites: favorites ?? this.favorites,
      trackIndex: trackIndex ?? this.trackIndex,
    );
  }

  @override
  List<Object> get props => [fetching, tracks, favorites, trackIndex];
}
