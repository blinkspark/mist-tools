import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/app_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.brown,
    ];
    final colorLabels = [
      '蓝色',
      '红色',
      '绿色',
      '橙色',
      '紫色',
      '青色',
      '粉色',
      '棕色',
    ];
    final themeModes = [
      ThemeMode.system,
      ThemeMode.light,
      ThemeMode.dark,
    ];
    final themeModeLabels = [
      '跟随系统',
      '浅色',
      '深色',
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('设置', style: Theme.of(context).textTheme.titleMedium),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text('主题颜色：', style: Theme.of(context).textTheme.bodyLarge),
              Obx(
                () => DropdownButton<MaterialColor>(
                  focusColor: Colors.transparent,
                  value: appController.seedColor.value,
                  items: List.generate(
                    colors.length,
                    (i) => DropdownMenuItem(
                      value: colors[i],
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: colors[i],
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(colorLabels[i]),
                        ],
                      ),
                    ),
                  ),
                  onChanged: (color) {
                    if (color != null) appController.seedColor.value = color;
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text('主题模式：', style: Theme.of(context).textTheme.bodyLarge),
              Obx(
                () => DropdownButton<ThemeMode>(
                  focusColor: Colors.transparent,
                  value: appController.themeMode.value,
                  items: List.generate(
                    themeModes.length,
                    (i) => DropdownMenuItem(
                      value: themeModes[i],
                      child: Text(themeModeLabels[i]),
                    ),
                  ),
                  onChanged: (mode) {
                    if (mode != null) appController.themeMode.value = mode;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
