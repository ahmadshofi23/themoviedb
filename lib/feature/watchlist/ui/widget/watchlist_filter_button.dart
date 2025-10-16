import 'package:flutter/material.dart';
import 'package:themoviedb/utils/color_palettes.dart';

class WatchlistFilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const WatchlistFilterButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              selected
                  ? ColorPalettes.primaryColor
                  : ColorPalettes.secondaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color:
                selected
                    ? ColorPalettes.secondaryColor
                    : ColorPalettes.greyColor,
          ),
        ),
      ),
    );
  }
}
