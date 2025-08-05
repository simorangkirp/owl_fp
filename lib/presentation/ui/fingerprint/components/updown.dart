import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant.dart';

class UpdownComponent extends StatelessWidget {
  const UpdownComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        children: [
          Text("Unduh & Kirim Template"),
          Divider(),
          SizedBox(height: 12.h),
          Text("Pilih Menu:"),
          SizedBox(height: 8.h),
          TextField(),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () {},
            child: Text('Kirim'),
          ),
        ],
      ),
    );
  }
}
