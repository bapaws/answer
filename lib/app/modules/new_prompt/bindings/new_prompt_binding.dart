import 'package:get/get.dart';

import '../controllers/new_prompt_controller.dart';

class NewPromptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewPromptController>(
      () => NewPromptController(),
    );
  }
}
