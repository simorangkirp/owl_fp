import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/template.controller.dart';

class TemplateScreen extends GetView<TemplateController> {
  const TemplateScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TemplateScreen'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'TemplateScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
