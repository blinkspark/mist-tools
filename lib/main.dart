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
    final appController = Get.find<AppController>();
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getThemeData(Brightness.light, appController.seedColor.value),
        darkTheme: getThemeData(Brightness.dark, appController.seedColor.value),
        themeMode: appController.themeMode.value,
        home: MainFrame(),
      );
    });
  }

  ThemeData getThemeData(Brightness brightness, Color seedColor) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ),
    );
    return baseTheme.copyWith(
      textTheme: GoogleFonts.notoSansScTextTheme(baseTheme.textTheme),
    );
  }
}
