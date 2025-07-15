import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/about.controller.dart';

class AboutScreen extends GetView<AboutController> {
  const AboutScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AboutScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AboutScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
