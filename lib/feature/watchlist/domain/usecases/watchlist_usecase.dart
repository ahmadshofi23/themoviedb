import 'package:dartz/dartz.dart';
import 'package:themoviedb/feature/watchlist/domain/entity/watchlist_entity.dart';
import 'package:themoviedb/feature/watchlist/domain/repositories/watchlist_repository.dart';

class WatchlistUsecase {
  final WatchlistRepository repository;

  WatchlistUsecase(this.repository);

  Future<Either<String, List<WatchlistEntity>>> getWatchlist() {
    return repository.getWatchlist();
  }

  Future<Either<String, void>> addToWatchlist(WatchlistEntity movie) {
    return repository.addWatchlist(movie);
  }

  Future<Either<String, bool>> isAdded(int id) {
    return repository.isAdded(id);
  }
}
