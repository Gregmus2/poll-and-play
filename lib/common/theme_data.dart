import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getThemeData(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.blue, foregroundColor: Colors.blue),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
      backgroundColor: const Color.fromRGBO(42, 45, 66, 1.0),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      labelTextStyle: MaterialStatePropertyAll(TextStyle(color: Colors.white, fontSize: 12)),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.notoSans(
        fontSize: 24,
        color: Colors.white,
      ),
      bodySmall: GoogleFonts.notoSans(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.notoSans(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
    ),
  );
}
