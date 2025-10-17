import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:themoviedb/feature/auth/domain/entity/auth_entity.dart';
import 'package:themoviedb/feature/auth/domain/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<ContinueAsGuest>(_onGuestLogin);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final user = await _authRepository.getAuthStatus();
    emit(AuthLoaded(user));
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final user = await _authRepository.login(event.email, event.password);
    emit(AuthLoaded(user));
  }

  Future<void> _onGuestLogin(
    ContinueAsGuest event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoaded(AuthEntity.guest()));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(AuthLoaded(AuthEntity.guest()));
  }
}
