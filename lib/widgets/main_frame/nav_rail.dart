import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controller.dart';

class NavRail extends StatelessWidget {
  const NavRail({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    return NavigationRail(
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.home), label: Text('主页')),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text('设置'),
        ),
      ],
      selectedIndex: appController.navIndex.value,
      onDestinationSelected: (int index) {
        appController.navIndex.value = index;
      },
    );
  }
}
