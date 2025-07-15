import 'package:get/get.dart';

class AboutController extends GetxController {
  final count = 0.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  Future<void> onClose() async {
    super.onClose();
  }

  void increment() => count.value++;
}
