import 'package:dartz/dartz.dart';
import 'package:themoviedb/feature/home/core/error/failure.dart';
import 'package:themoviedb/feature/home/domain/entity/genre_entity.dart';
import 'package:themoviedb/feature/home/domain/repositories/movie_repository.dart';

class GetGenres {
  final MovieRepository repository;
  GetGenres(this.repository);
  Future<Either<Failure, List<GenreEntity>>> call() {
    return repository.getGenres();
  }
}
