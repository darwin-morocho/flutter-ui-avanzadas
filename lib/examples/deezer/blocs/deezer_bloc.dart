import 'package:bloc/bloc.dart';
import 'package:modernui/examples/deezer/api/deezer_api.dart';
import 'deezer_events.dart';
import 'deezer_state.dart';

class DeezerBloc extends Bloc<DeezerEvents, DeezerState> {
  DeezerBloc() {
    final event = DeezerFetchEvent("Jósean Log");
    event.init();
    add(event);
  }

  @override
  DeezerState get initialState => DeezerState();

  @override
  Stream<DeezerState> mapEventToState(DeezerEvents event) async* {
    if (event is DeezerFetchEvent) {
      yield* _fetch(event);
    } else if (event is DeezerCurrentTrackEvent) {
      if (event.index >= 0 && event.index < this.state.tracks.length) {
        yield this.state.copyWith(trackIndex: event.index);
      }
    }
  }

  Stream<DeezerState> _fetch(DeezerFetchEvent event) async* {
    yield this.state.copyWith(fetching: true, tracks: []);
    final tracks = await DeezerAPI.search(event.query);
    yield this.state.copyWith(
          fetching: false,
          tracks: tracks,
          trackIndex: 0,
        );
    event.completer.complete();
  }
}
