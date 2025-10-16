part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class FetchWatchlistMovies extends WatchlistEvent {}

class AddMovieToWatchlist extends WatchlistEvent {
  final WatchlistEntity movie;

  const AddMovieToWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

class CheckIsMovieAdded extends WatchlistEvent {
  final int id;

  const CheckIsMovieAdded(this.id);

  @override
  List<Object?> get props => [id];
}
