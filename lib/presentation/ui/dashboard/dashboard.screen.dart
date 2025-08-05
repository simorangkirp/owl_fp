import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/navigation/routes.dart';
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
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: controller.listMD.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: ConstPadding.screenPadding,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8.w),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.masterdata,
                          arguments: {'args': controller.listMD[index]});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: ConstColor.gCultured,
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      padding: ConstPadding.screenPadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.listMD[index],
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            LucideIcons.chevronRight,
                            size: 18.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
