import 'package:answer/app/core/app/app_controller_mixin.dart';
import 'package:answer/app/data/models/conversation.dart';
import 'package:answer/app/data/models/group.dart';
import 'package:answer/app/data/models/prompt.dart';
import 'package:answer/app/modules/home/controllers/home_controller.dart';
import 'package:answer/app/providers/service_provider.dart';
import 'package:answer/app/providers/service_provider_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/app/app_toast.dart';
import '../../../data/db/app_database.dart';
import '../../../routes/app_pages.dart';

class ConversationController extends GetxController with AppControllerMixin {
  late Group group = Get.arguments['group'];
  late Conversation conversation = Get.arguments['conversation'];
  late final nameTextEditing = TextEditingController(
    text: conversation.name,
  );
  late final FocusNode nameFocusNode = FocusNode();

  late final List<ServiceProvider> providers =
      ServiceProviderManager.instance.providers;

  late final maxTokensTextEditing = TextEditingController();
  late final timeoutTextEditing = TextEditingController();

  Prompt? prompt;

  bool editing = false;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    maxTokensTextEditing.text = conversation.maxTokens.toString();
    timeoutTextEditing.text = conversation.timeout.toString();

    if (conversation.promptId != null) {
      prompt = await AppDatabase.instance.promptDao.get(
        id: conversation.promptId!,
      );
    }

    update();
    super.onReady();
  }

  void onEdited() {
    editing = true;
    update();
    // delay is working
    Future.delayed(const Duration(milliseconds: 100), () {
      nameFocusNode.requestFocus();
    });
  }

  void onBlocked(bool value, ServiceProvider serviceProvider) {}

  Future<void> onQuoted(bool value) async {
    conversation = conversation.copyWith(autoQuote: value ? 10 : 0);
    update();
    _updateHome();

    await AppDatabase.instance.conversationsDao.create(
      conversation,
    );
  }

  Future<void> onPrompted() async {
    final result = await Get.toNamed(Routes.prompt);
    if (result == null) return;

    prompt = result;
    conversation = conversation.copyWith(promptId: prompt!.id);

    update();
    _updateHome();

    await AppDatabase.instance.conversationsDao.create(
      conversation,
    );
  }

  Future<void> onSaved() async {
    editing = false;

    conversation = conversation.copyWith(
      name: nameTextEditing.text,
      maxTokens: int.tryParse(maxTokensTextEditing.text),
      timeout: int.tryParse(timeoutTextEditing.text),
      promptId: prompt?.id,
    );

    update();

    await AppDatabase.instance.conversationsDao.create(conversation);

    AppToast.show(msg: 'saved_successfully'.tr);

    _updateHome();
  }

  Future<void> onDeleted() async {
    await HomeController.to.deleteConversation(conversation);
    Get.back();
  }

  void _updateHome() {
    final home = HomeController.to;
    home.conversations[home.currentConversationIndex] = conversation;
    home.update();
  }
}
