import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/theme.controller.dart';

class ThemeScreen extends GetView<ThemeController> {
  const ThemeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Tema'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ThemeScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
