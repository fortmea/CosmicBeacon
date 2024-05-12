import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData meuTema =
    parcial.copyWith(textTheme: GoogleFonts.soraTextTheme(parcial.textTheme));

final ThemeData parcial = ThemeData(
  scaffoldBackgroundColor: const Color.fromRGBO(00, 00, 22, 1),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(00, 00, 22, 1),
    elevation: 0,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(
        Colors.white,
      ),
    ),
  ),
  colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(00, 00, 22, 1),
      brightness: Brightness.dark),
  useMaterial3: true,
);
