import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernui/examples/deezer/blocs/deezer_bloc.dart';
import 'package:modernui/examples/deezer/blocs/deezer_events.dart';
import 'package:modernui/examples/deezer/blocs/deezer_state.dart';
import 'package:modernui/examples/deezer/widgets/deezer_player.dart';
import 'package:modernui/utils/responsive.dart';

class DeezerPage extends StatefulWidget {
  static final routeName = 'Deezer';
  @override
  _DeezerPageState createState() => _DeezerPageState();
}

class _DeezerPageState extends State<DeezerPage> {
  final DeezerBloc _bloc = DeezerBloc();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.init(context);
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: BlocBuilder<DeezerBloc, DeezerState>(
          builder: (_, state) {
            if (state.fetching) {
              return Center(
                child: CupertinoActivityIndicator(
                  radius: 15,
                ),
              );
            }

            final deezerTrack = state.tracks[state.trackIndex];
            return Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "${state.trackIndex + 1} / ${state.tracks.length}",
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                child: CachedNetworkImage(
                                  imageUrl: deezerTrack.album.cover,
                                  placeholder: (_, __) {
                                    return Center(
                                      child: CupertinoActivityIndicator(),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              deezerTrack.title,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'raleway',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${deezerTrack.artist.name} - ${deezerTrack.album.title}",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'sans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      DezzerPlayer(
                        deezerTrack: deezerTrack,
                        onPrev: () {
                          _bloc.add(
                              DeezerCurrentTrackEvent(state.trackIndex - 1));
                        },
                        onNext: () {
                          _bloc.add(
                              DeezerCurrentTrackEvent(state.trackIndex + 1));
                        },
                      )
                    ],
                  ),
                ),
                DraggableScrollableSheet(
                  minChildSize: 0.1,
                  initialChildSize: 0.1,
                  maxChildSize: 1,
                  builder: (_, scrollController) {
                    return CustomScrollView(
                      controller: scrollController,
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: Container(
                            color: Colors.white,
                            child: SafeArea(
                              top: false,
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.keyboard_arrow_up),
                                    Text(
                                      "SONGS",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'sans',
                                        fontSize: 20,
                                        height: 1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                            delegate: SliverChildBuilderDelegate((_, index) {
                          final track = state.tracks[index];
                          return Container(
                            color: Colors.white,
                            child: ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: track.album.cover,
                              ),
                              onTap: () {
                                _bloc.add(
                                  DeezerCurrentTrackEvent(index),
                                );
                              },
                              title: Text(
                                track.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(track.album.title),
                            ),
                          );
                        }, childCount: state.tracks.length)),
                      ],
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
