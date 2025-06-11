import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();
    
    return Obx(() => NavigationDrawer(
      selectedIndex: controller.navIndex.value,
      onDestinationSelected: (index) {
        controller.navIndex.value = index;
        Navigator.pop(context); // 关闭抽屉
      },
      children: [
        // 头部区域
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            '导航菜单',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        // 导航项
        const NavigationDrawerDestination(
          label: Text('主页'),
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
        ),
        const NavigationDrawerDestination(
          label: Text('设置'),
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
        ),
      ],
    ));
  }
}
