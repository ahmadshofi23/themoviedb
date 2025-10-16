import 'package:themoviedb/feature/home/core/error/failure.dart';
import 'package:themoviedb/feature/home/domain/entity/movie_detail_entity.dart';
import 'package:themoviedb/feature/home/domain/entity/movie_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieEntity>>> getTrendingMovies();
  Future<Either<Failure, List<MovieEntity>>> getNowPlayingMovies();
  Future<Either<Failure, List<MovieEntity>>> getTopRatedMovies();
  Future<Either<Failure, MovieDetailEntity>> getMovieDetail(int id);
}
