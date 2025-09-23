import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/help.controller.dart';

class HelpScreen extends GetView<HelpController> {
  const HelpScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HelpScreen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'HelpScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
