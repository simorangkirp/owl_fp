import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant.dart';

class AdminComponent extends StatelessWidget {
  const AdminComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ConstPadding.screenPadding,
      child: ListView(
        children: [
          Text("Admin"),
          Divider(),
          SizedBox(height: 12.h),
          Text("Pilih Menu"),
          SizedBox(height: 8.h),
          TextField(),
        ],
      ),
    );
  }
}
