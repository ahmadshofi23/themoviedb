import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/feature/watchlist/domain/entity/watchlist_entity.dart';
import '../../domain/usecases/watchlist_usecase.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistUsecase usecase;

  WatchlistBloc({required this.usecase}) : super(WatchlistInitial()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(WatchlistLoading());
      final result = await usecase.getWatchlist();
      result.fold(
        (failure) => emit(WatchlistError(failure)),
        (movies) => emit(WatchlistLoaded(movies)),
      );
    });

    on<AddMovieToWatchlist>((event, emit) async {
      emit(WatchlistActionInProgress());
      final result = await usecase.addToWatchlist(event.movie);
      result.fold(
        (failure) => emit(WatchlistError(failure)),
        (_) => emit(WatchlistAddedSuccess(event.movie)),
      );
      add(FetchWatchlistMovies());
    });

    on<CheckIsMovieAdded>((event, emit) async {
      final result = await usecase.isAdded(event.id);
      result.fold(
        (error) => emit(WatchlistError(error)),
        (isAdded) => emit(IsMovieAddedState(isAdded)),
      );
    });
  }
}
