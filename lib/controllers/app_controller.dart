import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  final navIndex = 0.obs;
  final seedColor = Colors.blue.obs;
  final themeMode = ThemeMode.system.obs;
}