import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/language.controller.dart';

class LanguageScreen extends GetView<LanguageController> {
  const LanguageScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LanguageScreen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LanguageScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
