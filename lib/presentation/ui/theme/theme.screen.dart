import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/theme.controller.dart';

class ThemeScreen extends GetView<ThemeController> {
  const ThemeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ThemeScreen'),
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
