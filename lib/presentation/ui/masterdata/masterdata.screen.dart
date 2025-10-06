import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:owl_fp_newer/presentation/constant.dart';

import 'controllers/masterdata.controller.dart';

class MasterdataScreen extends StatelessWidget {
  MasterdataScreen({Key? key}) : super(key: key);
  final controller = Get.find<MasterdataController>();
  @override
  Widget build(BuildContext context) {
    var scrlCtrl = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title.value),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: ConstColor.gCultured,
            width: double.maxFinite,
            padding: ConstPadding.screenPadding,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${'lastSync'.tr}:",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Obx(
                        () => Text(
                          // 'Sabtu, 12 Desember 2025 12:12:12',
                          controller.lastUpdate.value,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => controller.onSyncKaryawan(),
                    child: Text(
                      "sync".tr,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: ConstPadding.screenPadding,
            child: TextFormField(
              onChanged: (value) {
                controller.searchData();
              },
              controller: controller.searchCtrl,
              decoration: const InputDecoration()
                  .applyDefaults(Theme.of(context).inputDecorationTheme)
                  .copyWith(
                    suffixIcon: IconButton(
                      icon: const Icon(LucideIcons.xCircle),
                      onPressed: () {
                        controller.searchCtrl.text = "";
                        controller.searchData();
                      },
                    ),
                    prefixIcon: const Icon(LucideIcons.search),
                  ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                controller: scrlCtrl,
                itemCount: controller.karyawanlist.length,
                itemBuilder: (context, index) {
                  var data = controller.karyawanlist[index];
                  return Padding(
                    padding: ConstPadding.listcontentPadding,
                    child: SizedBox(
                      child: Column(
                        children: [
                          Visibility(
                            visible: index != 0,
                            child: Divider(
                              thickness: 1.h,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(child: Text("name".tr)),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  data.namakaryawan ?? "Undifined",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text("NIK")),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    data.nik ?? "Undifined",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text("unit".tr)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    data.lokasitugas ?? "Undifined",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text("division".tr)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    data.subbagian ?? "Undifined",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text("position".tr)),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    data.kodejabatan ?? "Undifined",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
