// controllers/bottom_nav_controller.dart
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    currentIndex.value = 0;
  }
}
