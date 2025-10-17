import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String name;
  final String email;
  final String avatarUrl;
  final bool isGuest;

  const AuthEntity({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.isGuest,
  });

  @override
  List<Object?> get props => [name, email, avatarUrl, isGuest];

  factory AuthEntity.guest() => const AuthEntity(
    name: "Tamu TMDB",
    email: "tst@gmail.com",
    avatarUrl: "",
    isGuest: true,
  );
}
