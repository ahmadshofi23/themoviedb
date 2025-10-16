part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent {}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;
  FetchMovieDetail(this.id);
}
