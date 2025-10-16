part of 'movie_bloc.dart';

abstract class MovieEvent {}

class LoadMovies extends MovieEvent {
  final MovieCategory category;
  LoadMovies(this.category);
}
