import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:owl_fp/presentation/constant.dart';
import 'package:owl_fp/presentation/ui/template/controllers/template.controller.dart';

class TemplateScreen extends StatelessWidget {
  TemplateScreen({Key? key}) : super(key: key);
  final controller = Get.find<TemplateController>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          title: Text('Daftar Template'),
          centerTitle: true,
        ),
        body: Padding(
          padding: ConstPadding.screenPadding,
          child: ListView(
            children: [
              Text("SN Mesin :", style: theme.labelMedium),
              SizedBox(height: 4.h),
              FutureBuilder(
                future: controller.getSN(),
                builder: (context, snapshot) {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: null,
                    items: controller.listSN
                        .map((option) => DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            ))
                        .toList(),
                    onChanged: (value) {
                      controller.selectedSN.value = value ?? "";
                      controller.getKaryawan();
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select an option';
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 12.h),
              Text("Nama Karyawan :", style: theme.labelMedium),
              SizedBox(height: 4.h),
              Obx(
                () => TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    enabled: controller.selectedSN.value != "",
                    controller: controller.typeAheadTCtrl,
                    decoration: InputDecoration(
                      labelStyle: theme.labelLarge,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return controller.listKaryawan.where((item) {
                      var name = item;
                      return name.toLowerCase().contains(pattern.toLowerCase());
                    });
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(title: Text(suggestion));
                  },
                  onSuggestionSelected: (suggestion) {
                    controller.typeAheadTCtrl.text = suggestion;
                    controller.selectedKaryawan.value = suggestion;
                    controller.getTemplate();
                  },
                ),
              ),
              SizedBox(height: 12.h),
              Text("Daftar Fingerprint", style: theme.labelMedium),
              SizedBox(height: 8.h),
              Obx(
                () => controller.listTemplate.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.listTemplate.length,
                        itemBuilder: (context, index) {
                          var data = controller.listTemplate[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Icon(
                                    LucideIcons.fingerprint,
                                    size: 16.w,
                                  )),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      data,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ));
  }
}
