import 'package:equatable/equatable.dart';

class WatchlistEntity extends Equatable {
  final int id;
  final String title;
  final String posterPath;
  final double voteAverage;
  final String overview;
  final String type;

  const WatchlistEntity({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    required this.overview,
    required this.type,
  });

  String get fullPosterUrl => 'https://image.tmdb.org/t/p/w500$posterPath';

  @override
  List<Object?> get props => [id, title, posterPath, voteAverage, type];
}
