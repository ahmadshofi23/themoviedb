import 'package:dio/dio.dart';
import 'package:themoviedb/feature/home/data/models/movie_detail_model.dart';
import 'package:themoviedb/feature/home/data/models/movie_model.dart';

abstract class TmdbRemoteDataSource {
  Future<List<MovieModel>> getTrendingMovies();
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailModel> getMovieDetail(int id);
}

class TmdbRemoteDataSourceImpl implements TmdbRemoteDataSource {
  final Dio dio;
  final String apiKey;

  TmdbRemoteDataSourceImpl(this.dio, this.apiKey);

  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    final response = await dio.get(
      '/trending/movie/day',
      queryParameters: {'api_key': apiKey},
    );
    final results = response.data['results'] as List;
    return results.map((e) => MovieModel.fromJson(e)).toList();
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response = await dio.get(
      '/movie/now_playing',
      queryParameters: {'api_key': apiKey},
    );
    final results = response.data['results'] as List;
    return results.map((e) => MovieModel.fromJson(e)).toList();
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await dio.get(
      '/movie/top_rated',
      queryParameters: {'api_key': apiKey},
    );
    final results = response.data['results'] as List;
    return results.map((e) => MovieModel.fromJson(e)).toList();
  }

  @override
  Future<MovieDetailModel> getMovieDetail(int id) async {
    final response = await dio.get(
      '/movie/$id',
      queryParameters: {
        'api_key': apiKey,
        'append_to_response': 'credits',
        'language': 'id-ID',
      },
    );

    if (response.statusCode == 200) {
      return MovieDetailModel.fromJson(response.data);
    } else {
      throw Exception('Gagal mengambil detail film');
    }
  }
}
