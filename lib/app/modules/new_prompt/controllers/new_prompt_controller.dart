import 'package:answer/app/core/app/app_controller_mixin.dart';
import 'package:answer/app/data/db/app_database.dart';
import 'package:answer/app/data/db/app_uuid.dart';
import 'package:answer/app/data/models/prompt.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NewPromptController extends GetxController with AppControllerMixin {
  final titleTextEditing = TextEditingController();
  final contentTextEditing = TextEditingController();

  Prompt? prompt = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    if (prompt != null) {
      titleTextEditing.text = prompt!.title ?? '';
      contentTextEditing.text = prompt!.content ?? '';
    }
  }

  Future<void> onCreated() async {
    final prompt = Prompt(
      id: AppUuid.value,
      title: titleTextEditing.text,
      content: contentTextEditing.text,
    );
    await AppDatabase.instance.promptDao.create(
      prompt,
    );
    Get.back(result: prompt);
  }
}
