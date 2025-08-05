import 'package:get/get.dart';

class MasterdataController extends GetxController {
  var title = "".obs;

  @override
  void onInit() {
    title.value = Get.arguments['args'] ?? "Undefined";
    super.onInit();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
