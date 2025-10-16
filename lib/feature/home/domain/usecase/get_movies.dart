import 'package:dartz/dartz.dart';
import 'package:themoviedb/feature/home/core/error/failure.dart';
import 'package:themoviedb/feature/home/domain/entity/movie_category_entity.dart';
import 'package:themoviedb/feature/home/domain/entity/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetMovies {
  final MovieRepository repository;

  GetMovies(this.repository);

  Future<Either<Failure, List<MovieEntity>>> call(MovieCategory category) {
    switch (category) {
      case MovieCategory.trending:
        return repository.getTrendingMovies();
      case MovieCategory.nowPlaying:
        return repository.getNowPlayingMovies();
      case MovieCategory.topRated:
        return repository.getTopRatedMovies();
    }
  }
}
