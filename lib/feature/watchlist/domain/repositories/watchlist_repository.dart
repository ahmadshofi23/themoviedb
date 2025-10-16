import 'package:dartz/dartz.dart';
import 'package:themoviedb/feature/watchlist/domain/entity/watchlist_entity.dart';

abstract class WatchlistRepository {
  Future<Either<String, List<WatchlistEntity>>> getWatchlist();
  Future<Either<String, void>> addWatchlist(WatchlistEntity movie);
  Future<Either<String, bool>> isAdded(int id);
}
