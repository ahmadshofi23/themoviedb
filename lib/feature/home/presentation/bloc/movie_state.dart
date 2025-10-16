part of 'movie_bloc.dart';

abstract class MovieState {
  final MovieCategory category;
  const MovieState(this.category);
}

class MovieInitial extends MovieState {
  const MovieInitial() : super(MovieCategory.trending);
}

class MovieLoading extends MovieState {
  const MovieLoading(super.category);
}

class MovieLoaded extends MovieState {
  final List<MovieEntity> movies;
  const MovieLoaded(this.movies, MovieCategory category) : super(category);
}

class MovieError extends MovieState {
  final String message;
  const MovieError(this.message, MovieCategory category) : super(category);
}
