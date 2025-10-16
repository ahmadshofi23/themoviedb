import 'package:dartz/dartz.dart';
import 'package:themoviedb/feature/home/core/error/failure.dart';
import 'package:themoviedb/feature/home/domain/repositories/movie_repository.dart';
import '../entity/movie_detail_entity.dart';

class GetMovieDetail {
  final MovieRepository repository;
  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetailEntity>> call(int id) {
    return repository.getMovieDetail(id);
  }
}
