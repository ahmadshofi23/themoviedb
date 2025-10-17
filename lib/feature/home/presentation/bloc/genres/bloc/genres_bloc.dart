import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:themoviedb/feature/home/domain/entity/genre_entity.dart';
import 'package:themoviedb/feature/home/domain/usecase/get_genres.dart';

part 'genres_event.dart';
part 'genres_state.dart';

class GenresBloc extends Bloc<GenresEvent, GenresState> {
  final GetGenres usecase;
  GenresBloc({required this.usecase}) : super(GenresInitial()) {
    on<LoadGenres>((event, emit) async {
      try {
        emit(GenresLoading());
        final result = await usecase();
        result.fold(
          (failure) => emit(GenresError(failure.message)),
          (genres) => emit(GenresLoaded(genres)),
        );
      } catch (e) {
        emit(GenresError(e.toString()));
      }
    });
  }
}
