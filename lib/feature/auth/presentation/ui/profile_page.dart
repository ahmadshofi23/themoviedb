import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:themoviedb/feature/auth/presentation/ui/login_page.dart';
import 'package:themoviedb/feature/auth/domain/entity/profile_entity.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/profile/profile_event.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/profile/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthLoaded) {
      context.read<ProfileBloc>().add(UpdateProfileFromAuth(authState.user));
    } else {
      context.read<ProfileBloc>().add(LoadProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoaded) {
            context.read<ProfileBloc>().add(UpdateProfileFromAuth(state.user));
          } else if (state is AuthInitial) {
            context.read<ProfileBloc>().add(LoadProfile());
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final profile = state.profile;
              if (profile.isGuest) {
                return _buildGuestState();
              }
              if (profile.lastWatched.isEmpty) {
                return _buildEmptyHistory(profile);
              }
              return _buildProfileWithHistory(profile);
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProfileWithHistory(ProfileEntity profile) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(profile),
            const SizedBox(height: 24),
            const Text(
              "Terakhir Dilihat",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2 / 3,
              ),
              itemCount: profile.lastWatched.length,
              itemBuilder: (context, index) {
                final movie = profile.lastWatched[index];
                return _buildMovieCard(movie);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestState() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 20),
            const Text(
              "Tamu TMDB",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyHistory(ProfileEntity profile) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profile.avatarUrl ?? ""),
            ),
            const SizedBox(height: 12),
            Text(
              profile.name ?? "",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              profile.joinDate ?? "",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              "Belum ada film yang ditonton",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileEntity profile) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(profile.avatarUrl ?? ""),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.name ?? "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Bergabung ${profile.joinDate ?? ""}",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: _showBottomSheet,
        ),
      ],
    );
  }

  Widget _buildMovieCard(ProfileHistoryMovieEntity movie) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            movie.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              movie.label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Log Out"),
                subtitle: const Text(
                  "Pastikan untuk log out agar akunmu tetap aman",
                ),
                onTap: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
