import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:themoviedb/feature/auth/data/datasources/dummy_auth_repository.dart';
import 'package:themoviedb/feature/auth/domain/repository/auth_repository.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:themoviedb/feature/auth/presentation/ui/login_page.dart';

import 'package:themoviedb/feature/home/data/datasources/tmdb_remote_data_source.dart';
import 'package:themoviedb/feature/home/data/repositories/movie_repository_impl.dart';
import 'package:themoviedb/feature/home/domain/usecase/get_genres.dart';
import 'package:themoviedb/feature/home/domain/usecase/get_movie_detail.dart';
import 'package:themoviedb/feature/home/domain/usecase/get_movies.dart';
import 'package:themoviedb/feature/home/presentation/bloc/detail_movie/movie_detail_bloc.dart';
import 'package:themoviedb/feature/home/presentation/bloc/genres/bloc/genres_bloc.dart';
import 'package:themoviedb/feature/home/presentation/bloc/movie_bloc.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/profile/profile_event.dart';

import 'package:themoviedb/feature/watchlist/data/datasources/local_watchlist_data_source.dart';
import 'package:themoviedb/feature/watchlist/data/repositories/watchlist_repository_impl.dart';
import 'package:themoviedb/feature/watchlist/domain/usecases/watchlist_usecase.dart';

import 'package:themoviedb/feature/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:themoviedb/feature/watchlist/ui/bloc/watchlist_bloc.dart';

import 'package:themoviedb/splash_page.dart';
import 'package:themoviedb/utils/color_palettes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  );

  const apiKey = 'aaaecd5bf657119dd69ae2cda63780f3';

  final remoteDataSource = TmdbRemoteDataSourceImpl(dio, apiKey);
  final localWatchlistDataSource = WatchlistLocalDataSource();

  final movieRepository = MovieRepositoryImpl(remoteDataSource);
  final watchlistRepository = WatchlistRepositoryImpl(localWatchlistDataSource);
  final AuthRepository authRepository = DummyAuthRepository();

  final getMovies = GetMovies(movieRepository);
  final getMovieDetail = GetMovieDetail(movieRepository);
  final watchlistUsecase = WatchlistUsecase(watchlistRepository);
  final getGenres = GetGenres(movieRepository);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: getMovies),
        RepositoryProvider.value(value: getMovieDetail),
        RepositoryProvider.value(value: watchlistUsecase),
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: getGenres),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(authRepository)),
          BlocProvider(
            create:
                (_) =>
                    ProfileBloc(watchlistUsecase: watchlistUsecase)
                      ..add(LoadProfile()),
          ),
          BlocProvider(create: (_) => GenresBloc(usecase: getGenres)),
          BlocProvider(create: (_) => MovieBloc(getMovies)),
          BlocProvider(create: (_) => MovieDetailBloc(getMovieDetail)),
          BlocProvider(create: (_) => WatchlistBloc(usecase: watchlistUsecase)),
        ],
        child: const TMDBApp(),
      ),
    ),
  );
}

class TMDBApp extends StatelessWidget {
  const TMDBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Movie DB',
      theme: ThemeData(
        scaffoldBackgroundColor: ColorPalettes.secondaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorPalettes.primaryColor,
        ),
        useMaterial3: true,
      ),
      home: SplashPage(),
    );
  }
}
