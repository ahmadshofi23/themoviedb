import 'package:equatable/equatable.dart';
import 'package:themoviedb/feature/auth/domain/entity/auth_entity.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfileFromAuth extends ProfileEvent {
  final AuthEntity auth;
  UpdateProfileFromAuth(this.auth);

  @override
  List<Object?> get props => [auth];
}
