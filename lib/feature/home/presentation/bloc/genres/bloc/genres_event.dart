part of 'genres_bloc.dart';

sealed class GenresEvent extends Equatable {
  const GenresEvent();

  @override
  List<Object> get props => [];
}

class LoadGenres extends GenresEvent {}
