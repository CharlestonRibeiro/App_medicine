import 'package:app_medicine/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  final letterBoot = GoogleFonts.oswald(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: ColorsApp.white,
  );

  static final titleAppBar = GoogleFonts.prompt(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: ColorsApp.white,
  );

  static final titleSize1 = GoogleFonts.prompt(
    fontSize: 21,
    fontWeight: FontWeight.w600,
    color: ColorsApp.white,
  );

  static final titleSize2 = GoogleFonts.prompt(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: ColorsApp.black,
  );
}
