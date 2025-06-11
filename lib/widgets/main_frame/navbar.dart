import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controller.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    return Obx(() {
      return NavigationBar(
        selectedIndex: appController.navIndex.value,
        onDestinationSelected: (int index) {
          appController.navIndex.value = index;
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: '主页',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: '设置',
          ),
        ],
      );
    });
  }
}
