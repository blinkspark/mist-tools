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
                () => Row(
                  children: colors.map(
                    (color) {
                      return GestureDetector(
                        onTap: () => appController.seedColor.value = color,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: appController.seedColor.value == color
                                ? Border.all(width: 3, color: Colors.black)
                                : null,
                          ),
                        ),
                      );
                    },
                  ).toList(),
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
