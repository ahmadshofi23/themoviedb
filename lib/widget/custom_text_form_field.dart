import 'package:flutter/material.dart';
import 'package:themoviedb/utils/color_palettes.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.height,
    required this.title,
    this.controller,
    required this.validator,
  });

  final double height;
  final String title;
  final TextEditingController? controller;
  String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: TextFormField(
        validator: validator,
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: height * 0.02),
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(fontSize: height * 0.018),
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: ColorPalettes.primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(width: 0.5, color: ColorPalettes.greyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: ColorPalettes.primaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
