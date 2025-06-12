import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mist_tools/services/app_config_service.dart';

class AppController extends GetxController {
  final navIndex = 0.obs;
  final seedColor = const Color(0xFF2196F3).obs; // Colors.blue.shade500
  final themeMode = ThemeMode.system.obs;
  final logger = Get.find<Logger>();
  final IAppConfigService appConfigService = Get.find<IAppConfigService>();

  @override
  void onInit() {
    super.onInit();
    seedColor.value = appConfigService.seedColor;
    themeMode.value = appConfigService.themeMode;
    // 初始化时可以加载用户设置或其他必要数据
    // ever(navIndex, (index) {
    //   // 监听导航索引的变化
    // });
    ever(seedColor, (color) {
      logger.d('主题颜色变化: ${color.toARGB32()}');
      appConfigService.setSeedColor(color);
    });
    ever(themeMode, (mode) {
      logger.d('主题模式变化: $mode');
      appConfigService.setThemeMode(mode);
    });
  }
}
