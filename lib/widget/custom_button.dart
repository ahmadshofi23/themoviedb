import 'package:flutter/material.dart';
import 'package:themoviedb/utils/color_palettes.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.height,
    required this.widht,
    required this.title,
    required this.isActiveBaground,
    this.onPress,
  });

  final double height;
  final double widht;
  final String title;
  final bool isActiveBaground;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.07,
      width: widht,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isActiveBaground
                  ? ColorPalettes.primaryColor
                  : ColorPalettes.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: ColorPalettes.primaryColor),
          ),
        ),
        onPressed: onPress,
        child: Text(
          title,
          style: TextStyle(
            color:
                isActiveBaground
                    ? ColorPalettes.secondaryColor
                    : ColorPalettes.primaryColor,
          ),
        ),
      ),
    );
  }
}
