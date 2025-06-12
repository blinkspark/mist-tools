import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AppConfig {
  Color seedColor;
  ThemeMode themeMode;
  Locale locale;
  AppConfig({
    this.seedColor = const Color(0xFF2196F3), // Colors.blue.shade500
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('zh', 'CN'),
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      seedColor: Color(json['seedColor'] as int),
      themeMode: ThemeMode.values[json['themeMode'] as int],
      locale: Locale(
        json['locale']['languageCode'] as String,
        json['locale']['countryCode'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seedColor': seedColor.toARGB32(),
      'themeMode': themeMode.index,
      'locale': {
        'languageCode': locale.languageCode,
        'countryCode': locale.countryCode,
      },
    };
  }
}

abstract class IAppConfigService {
  Color get seedColor;
  Future<void> setSeedColor(Color value);
  ThemeMode get themeMode;
  Future<void> setThemeMode(ThemeMode value);
  Locale get locale;
  Future<void> setLocale(Locale value);
}

class AppConfigService implements IAppConfigService {
  AppConfig? config;
  String configFileName = 'app_config.json';
  Logger logger = Get.find<Logger>();
  bool _initialized = false;

  // 初始化方法
  Future<void> init() async {
    if (!_initialized) {
      await loadConfig();
      _initialized = true;
      logger.d('AppConfigService 初始化完成');
    }
  }

  Future<String> get configFilePath async {
    return join((await getApplicationSupportDirectory()).path, configFileName);
  }

  Future<void> loadConfig() async {
    final path = await configFilePath;
    logger.d('加载配置文件路径: $path');
    try {
      final file = File(path);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        config = AppConfig.fromJson(json.decode(jsonString));
      }
    } catch (e) {
      logger.e('加载配置失败: $e');
    }
  }

  Future<void> saveConfig() async {
    final path = await configFilePath;
    logger.d('保存配置到: $path');
    try {
      final file = File(path);
      await file.create(recursive: true);
      final jsonString = json.encode(config?.toJson());
      await file.writeAsString(jsonString);
    } catch (e) {
      logger.e('保存配置失败: $e');
    }
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('AppConfigService 尚未初始化，请先调用 init() 方法');
    }
  }
  @override
  Color get seedColor {
    _ensureInitialized();
    return config?.seedColor ?? const Color(0xFF2196F3); // Colors.blue.shade500
  }

  @override
  Future<void> setSeedColor(Color value) async {
    _ensureInitialized();
    config ??= AppConfig();
    config!.seedColor = value;
    await saveConfig();
  }

  @override
  ThemeMode get themeMode {
    _ensureInitialized();
    return config?.themeMode ?? ThemeMode.system;
  }

  @override
  Future<void> setThemeMode(ThemeMode value) async {
    _ensureInitialized();
    config ??= AppConfig();
    config!.themeMode = value;
    await saveConfig();
  }

  @override
  Locale get locale {
    _ensureInitialized();
    return config?.locale ?? const Locale('zh', 'CN');
  }

  @override
  Future<void> setLocale(Locale value) async {
    _ensureInitialized();
    config ??= AppConfig();
    config!.locale = value;
    await saveConfig();
  }
}
