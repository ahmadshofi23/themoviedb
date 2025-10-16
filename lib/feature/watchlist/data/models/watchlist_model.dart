import 'package:themoviedb/feature/watchlist/domain/entity/watchlist_entity.dart';

class WatchlistModel extends WatchlistEntity {
  const WatchlistModel({
    required super.id,
    required super.title,
    required super.posterPath,
    required super.voteAverage,
    required super.overview,
    required super.type,
  });

  factory WatchlistModel.fromMap(Map<String, dynamic> map) {
    return WatchlistModel(
      id: map['id'],
      title: map['title'] ?? '',
      posterPath: map['posterPath'] ?? '',
      voteAverage: (map['voteAverage'] ?? 0).toDouble(),
      overview: map['overview'] ?? '',
      type: map['type'] ?? 'Film',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'posterPath': posterPath,
    'voteAverage': voteAverage,
    'overview': overview,
    'type': type,
  };
}
