import 'package:meta/meta.dart';

class DeezerTrack {
  final int id, duration, rank;
  final String title, preview;
  final Artist artist;
  final Album album;

  DeezerTrack({
    @required this.id,
    @required this.duration,
    @required this.rank,
    @required this.preview,
    @required this.title,
    @required this.artist,
    @required this.album,
  });

  factory DeezerTrack.fromJson(Map<String, dynamic> json) {
    return DeezerTrack(
      id: json['id'],
      duration: json['duration'],
      rank: json['rank'],
      preview: json['preview'],
      title: json['title'],
      artist: Artist.fromJson(json['artist']),
      album: Album.fromJson(json['album']),
    );
  }
}

class Artist {
  final int id;
  final String name, picture;

  Artist({
    @required this.id,
    @required this.name,
    @required this.picture,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      picture: json['picture_big'],
    );
  }
}

class Album {
  final int id;
  final String title, cover;

  Album({
    @required this.id,
    @required this.title,
    @required this.cover,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
      cover: json['cover_big'],
    );
  }
}
