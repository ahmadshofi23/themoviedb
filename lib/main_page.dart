import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/feature/home/presentation/ui/home_page.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:themoviedb/feature/auth/presentation/ui/login_page.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/profile/profile_event.dart';
import 'package:themoviedb/feature/auth/presentation/ui/profile_page.dart';
import 'package:themoviedb/feature/watchlist/ui/ui/watchlist_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    WatchlistPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoaded) {
          context.read<ProfileBloc>().add(UpdateProfileFromAuth(state.user));
        } else if (state is AuthInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      },
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          if (_selectedIndex != 0) {
            setState(() => _selectedIndex = 0);
            return false;
          }
          return true;
        },
        child: Scaffold(
          body: IndexedStack(index: _selectedIndex, children: _pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_outline),
                activeIcon: Icon(Icons.bookmark),
                label: 'Watchlist',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
