import 'package:answer/app/core/app/app_controller_mixin.dart';
import 'package:answer/app/data/db/app_database.dart';
import 'package:get/get.dart';

import '../../../data/models/prompt.dart';
import '../../../routes/app_pages.dart';

class PromptController extends GetxController with AppControllerMixin {
  final List<Prompt> prompts = [];

  @override
  Future<void> onReady() async {
    prompts.addAll(
      await AppDatabase.instance.promptDao.getAll(),
    );

    update();
    super.onReady();
  }

  Future<void> onNew() async {
    final prompt = await Get.toNamed(Routes.newPrompt);
    if (prompt != null) {
      prompts.add(prompt);
      update();
    }
  }

  Future<void> onEdited(Prompt prompt) async {
    final result = await Get.toNamed(
      Routes.newPrompt,
      arguments: prompt,
    );
    if (result != null) {
      final index = prompts.indexWhere((element) => element.id == result.id);
      prompts[index] = result;
      update();
    }
  }

  Future<void> onDeleted(Prompt prompt) async {
    prompts.removeWhere((element) => element.id == prompt.id);
    update();

    await AppDatabase.instance.promptDao.delete(prompt);
  }
}
