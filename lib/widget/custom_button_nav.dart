import 'package:flutter/material.dart';
import 'package:themoviedb/utils/color_palettes.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: ColorPalettes.secondaryColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: ColorPalettes.blackColor.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home_outlined, 'Beranda', 0),
            _buildNavItem(Icons.bookmark, 'Watchlist', 1, showLabel: true),
            _buildNavItem(Icons.person_outline, 'Profil', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index, {
    bool showLabel = false,
  }) {
    final bool isActive = currentIndex == index;

    if (isActive) {
      // Tombol aktif berbentuk pil dengan teks & ikon putih
      return GestureDetector(
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: ColorPalettes.primaryColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              Icon(icon, color: ColorPalettes.secondaryColor, size: 22),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: ColorPalettes.secondaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Tombol tidak aktif hanya ikon abu-abu
      return GestureDetector(
        onTap: () => onTap(index),
        child: Icon(icon, color: ColorPalettes.greyColor, size: 24),
      );
    }
  }
}
