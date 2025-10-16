part of 'watchlist_bloc.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<WatchlistEntity> movies;

  const WatchlistLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}

class WatchlistActionInProgress extends WatchlistState {}

class WatchlistAddedSuccess extends WatchlistState {
  final WatchlistEntity movie;

  const WatchlistAddedSuccess(this.movie);

  @override
  List<Object?> get props => [movie];
}

class WatchlistRemovedSuccess extends WatchlistState {
  final int movieId;

  const WatchlistRemovedSuccess(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class IsMovieAddedState extends WatchlistState {
  final bool isAdded;

  const IsMovieAddedState(this.isAdded);

  @override
  List<Object?> get props => [isAdded];
}
