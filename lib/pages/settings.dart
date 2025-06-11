import 'package:flutter/material.dart';

import '../widgets/main_frame/nav_drawer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      drawer: NavDrawer(),
      body: Center(
        child: Text(
          '设置页面内容',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
