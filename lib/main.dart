import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controllers/app_controller.dart';
import 'pages/main_frame.dart';

void main() {
  Get.put(AppController());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getThemeData(Brightness.light),
      darkTheme: getThemeData(Brightness.dark),
      themeMode: ThemeMode.system,
      home: MainFrame(),
    );
  }

  ThemeData getThemeData(Brightness brightness) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: brightness,
      ),
    );
    return baseTheme.copyWith(
      textTheme: GoogleFonts.notoSansScTextTheme(baseTheme.textTheme),
    );
  }
}
