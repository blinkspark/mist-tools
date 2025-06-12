import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mist_tools/widgets/settings/setting_section.dart';

import '../controllers/app_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final colors = [
      const Color(0xFF2196F3), // 蓝色
      const Color(0xFFF44336), // 红色
      const Color(0xFF4CAF50), // 绿色
      const Color(0xFFFF9800), // 橙色
      const Color(0xFF9C27B0), // 紫色
      const Color(0xFF009688), // 青色
      const Color(0xFFE91E63), // 粉色
      const Color(0xFF795548), // 棕色
    ];
    final colorLabels = ['蓝色', '红色', '绿色', '橙色', '紫色', '青色', '粉色', '棕色'];
    final themeModes = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
    final themeModeLabels = ['跟随系统', '浅色', '深色'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('设置', style: Theme.of(context).textTheme.titleMedium),
          ),
          SettingSection(
            title: '用户',
            children: [
              SettingSectionItem(
                title: '登录',
                onPressed: () {},
              ),
            ],
          ),
          SettingSection(
            title: '主题',
            children: [
              SettingSectionItem(
                title: '主题颜色',
                trailing: Obx(
                  () => DropdownButton<Color>(
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
                onPressed: () {},
              ),
              SettingSectionItem(
                title: '主题模式',
                trailing: Obx(
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
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
