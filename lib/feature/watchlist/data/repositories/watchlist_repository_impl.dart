import 'package:dartz/dartz.dart';
import 'package:themoviedb/feature/watchlist/data/datasources/local_watchlist_data_source.dart';
import 'package:themoviedb/feature/watchlist/data/models/watchlist_model.dart';
import 'package:themoviedb/feature/watchlist/domain/entity/watchlist_entity.dart';
import 'package:themoviedb/feature/watchlist/domain/repositories/watchlist_repository.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;

  WatchlistRepositoryImpl(this.localDataSource);

  @override
  Future<Either<String, List<WatchlistEntity>>> getWatchlist() async {
    try {
      final result = await localDataSource.getWatchlist();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> addWatchlist(WatchlistEntity movie) async {
    try {
      await localDataSource.insertWatchlist(
        WatchlistModel(
          id: movie.id,
          title: movie.title,
          posterPath: movie.posterPath,
          voteAverage: movie.voteAverage,
          overview: movie.overview,
          type: movie.type,
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> isAdded(int id) async {
    try {
      final result = await localDataSource.isAddedToWatchlist(id);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
