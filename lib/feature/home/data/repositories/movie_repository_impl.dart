import 'package:dartz/dartz.dart';
import 'package:themoviedb/feature/home/core/error/failure.dart';
import 'package:themoviedb/feature/home/data/datasources/tmdb_remote_data_source.dart';
import 'package:themoviedb/feature/home/domain/entity/genre_entity.dart';
import 'package:themoviedb/feature/home/domain/entity/movie_detail_entity.dart';
import 'package:themoviedb/feature/home/domain/entity/movie_entity.dart';
import 'package:themoviedb/feature/home/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final TmdbRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MovieEntity>>> getTrendingMovies() async {
    try {
      final result = await remoteDataSource.getTrendingMovies();
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getNowPlayingMovies() async {
    try {
      final result = await remoteDataSource.getNowPlayingMovies();
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getTopRatedMovies() async {
    try {
      final result = await remoteDataSource.getTopRatedMovies();
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieDetailEntity>> getMovieDetail(int id) async {
    try {
      final model = await remoteDataSource.getMovieDetail(id);
      final entity = model.toEntity(); // ubah model ke entity
      return Right(entity);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GenreEntity>>> getGenres() async {
    try {
      final result = await remoteDataSource.getGenres();
      final entities = result.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
