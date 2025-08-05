import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../../constant.dart';
import '../controllers/bt.controller.dart';

class RegisterComponent extends StatelessWidget {
  RegisterComponent({super.key});
  final btctrl = Get.find<BluetoothController>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController typeAheadController = TextEditingController();
    final List<String> sglist = [
      'Apple',
      'Banana',
      'Cherry',
      'Durian',
      'Grapes',
      'Orange',
      'Papaya',
    ];
    final theme = Theme.of(context).textTheme;

    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        children: [
          Text("Registrasi Fingerprint"),
          Divider(),
          SizedBox(height: 12.h),
          // Text("Pilih Karyawan:"),
          TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: typeAheadController,
              decoration: InputDecoration(
                labelStyle: theme.labelLarge,
                labelText: 'Cari buah',
                border: OutlineInputBorder(),
              ),
            ),
            suggestionsCallback: (pattern) {
              return sglist.where(
                  (item) => item.toLowerCase().contains(pattern.toLowerCase()));
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion));
            },
            onSuggestionSelected: (suggestion) {
              typeAheadController.text = suggestion;
            },
          ),
          Visibility(
              visible: typeAheadController.text.isNotEmpty,
              child: SizedBox(height: 8.h)),
          Visibility(
              visible: typeAheadController.text.isNotEmpty,
              child: Text("Pattern")),
          Visibility(
              visible: typeAheadController.text.isNotEmpty,
              child: SizedBox(height: 8.h)),
          Visibility(
            visible: typeAheadController.text.isNotEmpty,
            child: Container(
              width: double.maxFinite,
              height: 0.3.sh,
              color: Colors.grey[200],
            ),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () async {
              btctrl.waitRegist();
              await btctrl.sendRegist();
            },
            child: Text('Kirim'),
          ),
        ],
      ),
    );
  }
}
