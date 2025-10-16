part of 'movie_detail_bloc.dart';

abstract class MovieDetailState {}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetailEntity movie;
  MovieDetailLoaded(this.movie);
}

class MovieDetailError extends MovieDetailState {
  final String message;
  MovieDetailError(this.message);
}
