import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_fp/presentation/constant.dart';

import 'controllers/masterdata.controller.dart';

class MasterdataScreen extends StatelessWidget {
  MasterdataScreen({Key? key}) : super(key: key);
  final controller = Get.find<MasterdataController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title.value),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            color: ConstColor.gBlueGray,
            width: double.maxFinite,
            padding: ConstPadding.screenPadding,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Terakhir sinkron :'),
                      SizedBox(height: 4.h),
                      Text('Sabtu, 12 Desember 2025 12:12:12'),
                    ],
                  ),
                ),
                Expanded(child: Text("Sinkron")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
