import 'package:bloc/bloc.dart';
import 'package:themoviedb/feature/auth/domain/entity/profile_entity.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/profile/profile_event.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/profile/profile_state.dart';
import 'package:themoviedb/feature/watchlist/domain/usecases/watchlist_usecase.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final WatchlistUsecase watchlistUsecase;
  ProfileBloc({required this.watchlistUsecase}) : super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileFromAuth>(_onUpdateProfileFromAuth);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final guest = ProfileEntity.guest();
    emit(ProfileLoaded(guest));
  }

  Future<void> _onUpdateProfileFromAuth(
    UpdateProfileFromAuth event,
    Emitter<ProfileState> emit,
  ) async {
    final user = event.auth;
    final dummyHistory = <ProfileHistoryMovieEntity>[];
    final watchlistResult = await watchlistUsecase.getWatchlist();
    watchlistResult.fold(
      (failure) {
        // Jika gagal mengambil watchlist, tetap gunakan daftar kosong
      },
      (watchlist) {
        print('poster pat nya apa ${watchlist.map((e) => e.posterPath)}');
        for (var movie in watchlist) {
          dummyHistory.add(
            ProfileHistoryMovieEntity(
              imageUrl:
                  movie.fullPosterUrl ??
                  'https://via.placeholder.com/150x225?text=No+Image',
              label: movie.type != "movie" ? 'Film' : 'Serial TV',
            ),
          );
        }
      },
    );

    // // 🧪 Daftar film dummy
    // final dummyHistory = [
    //   const ProfileHistoryMovieEntity(
    //     imageUrl:
    //         'https://image.tmdb.org/t/p/w500/8Y43POKjjKDGI9MH89NW0NAzzp8.jpg',
    //     label: 'Film',
    //   ),
    //   const ProfileHistoryMovieEntity(
    //     imageUrl:
    //         'https://image.tmdb.org/t/p/w500/r2J02Z2OpNTctfOSN1Ydgii51I3.jpg',
    //     label: 'Serial TV',
    //   ),
    //   const ProfileHistoryMovieEntity(
    //     imageUrl:
    //         'https://image.tmdb.org/t/p/w500/62HCnUTziyWcpDaBO2i1DX17ljH.jpg',
    //     label: 'Film',
    //   ),
    //   const ProfileHistoryMovieEntity(
    //     imageUrl:
    //         'https://image.tmdb.org/t/p/w500/2RSirqZG949GuRwN38MYCIGG4Od.jpg',
    //     label: 'Serial TV',
    //   ),
    // ];

    final profile = ProfileEntity(
      name: user.name,
      avatarUrl:
          user.avatarUrl ??
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.name ?? "User")}',
      joinDate: "Oktober 2025",
      isGuest: user.isGuest,
      lastWatched: dummyHistory,
    );

    emit(ProfileLoaded(profile));
  }
}
