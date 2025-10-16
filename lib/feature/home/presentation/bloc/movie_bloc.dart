import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/feature/home/domain/entity/movie_category_entity.dart';
import 'package:themoviedb/feature/home/domain/entity/movie_entity.dart';
import 'package:themoviedb/feature/home/domain/usecase/get_movies.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovies getMovies;
  final Map<MovieCategory, List<MovieEntity>> _cache = {};

  MovieBloc(this.getMovies) : super(const MovieInitial()) {
    on<LoadMovies>((event, emit) async {
      emit(MovieLoading(event.category));

      if (_cache.containsKey(event.category)) {
        emit(MovieLoaded(_cache[event.category]!, event.category));
        return;
      }

      final result = await getMovies(event.category);
      result.fold(
        (failure) => emit(MovieError(failure.message, event.category)),
        (movies) {
          _cache[event.category] = movies;
          emit(MovieLoaded(movies, event.category));
        },
      );
    });
  }
}
