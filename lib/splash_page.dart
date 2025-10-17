import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:themoviedb/feature/auth/presentation/ui/login_page.dart';
import 'package:themoviedb/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _navigateAfterDelay();
    super.initState();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    context.read<AuthBloc>().add(CheckAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    var widht = MediaQuery.of(context).size.width;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoaded) {
          if (state.user.isGuest) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainPage()),
            );
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Image.asset('assets/logo.png', width: widht * 0.3),
              Text(
                'TMDB',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
              ),
              Spacer(),

              Image.asset('assets/tiketux.png', width: widht * 0.2),
            ],
          ),
        ),
      ),
    );
  }
}
