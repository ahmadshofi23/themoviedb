import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/feature/home/domain/entity/movie_detail_entity.dart';
import 'package:themoviedb/feature/home/domain/usecase/get_movie_detail.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc(this.getMovieDetail) : super(MovieDetailInitial()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailLoading());
      final result = await getMovieDetail(event.id);
      result.fold(
        (failure) => emit(MovieDetailError(failure.message)),
        (movie) => emit(MovieDetailLoaded(movie)),
      );
    });
  }
}
