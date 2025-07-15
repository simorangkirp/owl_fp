import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:owl_fp/presentation/ui/dashboard/dashboard.screen.dart';
import 'package:owl_fp/presentation/ui/profile/profile.screen.dart';

import '../../theme/btm.navbar.ctrl.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final controller = Get.put(BottomNavController());

  final pages = [
    DashboardScreen(), // halaman utama dashboard
    ProfileScreen(), // halaman profil dashboard
  ];
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: pages[controller.currentIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(LucideIcons.layoutDashboard), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(
                    LucideIcons.user,
                  ),
                  label: "Profile"),
            ],
          ),
        ));
  }
}
