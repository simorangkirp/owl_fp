import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../constant.dart';
import 'controllers/dashboard.controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);
  final controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.refresh),
        title: const Align(
            alignment: Alignment.centerRight,
            child: Text('OWL Mobile - Fingerprint')),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            color: ConstColor.gCultured,
            child: Padding(
              padding: ConstPadding.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Menu",
                    style:
                        theme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 16.h),
                  GetBuilder<DashboardController>(builder: (x) {
                    return Obx(
                      () => GridView.builder(
                        shrinkWrap: true,
                        itemCount: x.menuItem.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 8.h,
                        ),
                        itemBuilder: (context, index) {
                          var data = x.menuItem[index];
                          return Column(
                            children: [
                              Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(240),
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(data.path);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xff009688)
                                            .withOpacity(0.2),
                                      ),
                                      padding: EdgeInsets.all(12.w),
                                      child: Icon(
                                        data.menuIcon,
                                        color: ConstColor.lBerBlue,
                                        size: 24.w,
                                      )),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(data.menuNm),
                            ],
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: ConstPadding.screenPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Master Data",
                  style:
                      theme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  "Lihat Semua",
                  style: theme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700, color: ConstColor.gBlueGray),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
