import 'package:flutter/material.dart';
import 'package:themoviedb/utils/color_palettes.dart';

class EmptyWatchlist extends StatelessWidget {
  const EmptyWatchlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/empty_watchlist.png', width: 200, height: 200),
            const SizedBox(height: 24),
            const Text(
              'Watchlist Kosong',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan film atau serial favoritmu agar mudah ditemukan kembali.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: ColorPalettes.greyColor),
            ),
          ],
        ),
      ),
    );
  }
}
