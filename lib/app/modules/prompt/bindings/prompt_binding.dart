import 'package:get/get.dart';

import '../controllers/prompt_controller.dart';

class PromptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromptController>(
      () => PromptController(),
    );
  }
}
