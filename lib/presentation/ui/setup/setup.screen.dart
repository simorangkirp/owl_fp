import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/setup.controller.dart';

class SetupScreen extends GetView<SetupController> {
  const SetupScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SetupScreen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'SetupScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
