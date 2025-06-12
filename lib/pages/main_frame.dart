import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mist_tools/pages/settings.dart';

import '../controllers/app_controller.dart';
import '../widgets/main_frame/navbar.dart';

class MainFrame extends GetResponsiveView {
  MainFrame({super.key});

  @override
  Widget builder() {
    final appController = Get.find<AppController>();
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Obx(() {
              return Text(getTitle(appController.navIndex.value));
            }),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          body: Obx(() {
            return getPage(appController.navIndex.value);
          }),
          bottomNavigationBar: Navbar(),
        );
      },
    );
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return '主页';
      case 1:
        return '设置';
      default:
        return '未知页面';
    }
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return Center(child: Text('主页内容'));
      case 1:
        return SettingsPage();
      default:
        return Center(child: Text('未知页面'));
    }
  }
}
