import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'components/admin.dart';
import 'components/deviceinfo.dart';
import 'components/finger.dart';
import 'components/register.dart';
import 'components/setting.dart';
import 'components/updown.dart';
import 'controllers/fingerprint.controller.dart';

class FingerprintScreen extends GetView<FingerprintController> {
  const FingerprintScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pengaturan Fingerprint'),
          bottom: const TabBar(
            automaticIndicatorColorAdjustment: true,
            indicatorColor: Colors.black,
            tabs: [
              Tab(
                icon: Icon(Icons.bluetooth),
              ),
              Tab(
                icon: Icon(Icons.settings),
              ),
              Tab(
                icon: Icon(Icons.fingerprint),
              ),
              Tab(
                icon: Icon(Icons.cloud_download_outlined),
              ),
              Tab(
                icon: Icon(Icons.person),
              ),
              Tab(
                icon: Icon(Icons.sd_storage_outlined),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FingerComponents(),
            SettingComponents(),
            RegisterComponent(),
            UpdownComponent(),
            AdminComponent(),
            DeviceInfoComponent(),
          ],
        ),
      ),
    );
  }
}
