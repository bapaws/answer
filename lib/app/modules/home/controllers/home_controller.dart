import 'dart:core';

import 'package:answer/app/core/app/app_controller_mixin.dart';
import 'package:answer/app/core/app/app_hive_keys.dart';
import 'package:answer/app/core/app/app_manager.dart';
import 'package:answer/app/core/app/app_toast.dart';
import 'package:answer/app/core/mixin/refresh_mixin.dart';
import 'package:answer/app/data/db/app_database.dart';
import 'package:answer/app/data/models/group.dart';
import 'package:answer/app/providers/service_provider_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import '../../../data/db/app_uuid.dart';
import '../../../data/models/conversation.dart';
import '../../../data/models/message.dart';
import '../../../routes/app_pages.dart';
import 'home_drawer_controller.dart';

class HomeController extends GetxController
    with AppControllerMixin, RefreshMixin {
  static HomeController to = Get.find();
  late final List<Message> messages = [];

  int _currentConversationIndex = -1;
  int get currentConversationIndex => _currentConversationIndex;
  set currentConversationIndex(int currentConversationIndex) {
    if (_currentConversationIndex == currentConversationIndex) return;
    _currentConversationIndex = currentConversationIndex;
    AppManager.to.set(
      key: currentConversationIndexHiveKey,
      value: currentConversationIndex,
    );
  }

  Message? currentQuotedMessage;

  final List<Conversation> conversations = [];
  final List<HomeDrawerController> homeDrawerControllers = [];

  Conversation? get currentConversation =>
      conversations.isEmpty || currentConversationIndex == -1
          ? null
          : conversations[currentConversationIndex];

  String get currentConversationIndexHiveKey =>
      groups[currentGroupIndex].id.toString() +
      AppHiveKeys.currentConversationIndex;

  @override
  late final scroll = ScrollController();

  late final focusNode = FocusNode();
  late final textEditing = TextEditingController();

  int currentGroupIndex = 0;
  late final groups = <Group>[
    Group(id: 0, name: 'Conversation AI', avatar: '', title: 'Conversation'),
  ];

  String get title =>
      currentConversation?.editName ?? groups[currentGroupIndex].title;

  @override
  Future<void> onInit() async {
    currentGroupIndex = AppManager.to.get(
          key: AppHiveKeys.currentGroupIndex,
        ) ??
        0;

    await changeGroup(currentGroupIndex);

    // Remove splash after home page update
    FlutterNativeSplash.remove();

    super.onInit();
  }

  Future<void> onSubmitted(String value) async {
    if (value.isEmpty) {
      AppToast.show(msg: 'unable_send'.tr);
      return;
    }

    final message = Message(
      id: AppUuid.value,
      type: MessageType.text,
      fromType: MessageFromType.send,
      content: value,
      createAt: DateTime.now(),
      conversationId: currentConversation!.id,
    );
    await AppDatabase.instance.messagesDao.create(message);
    messages.insert(0, message);
    update();

    final providers = await ServiceProviderManager.to.getAll(
      group: groups[currentGroupIndex],
      conversation: currentConversation!,
    );
    for (final item in providers) {
      item.send(
        conversation: currentConversation!,
        message: message,
      );
    }
  }

  Future<void> onReceived(Message message) async {
    if (message.type != MessageType.loading) {
      await AppDatabase.instance.messagesDao.create(message);
    }

    final loadingIndex = messages.indexWhere(
      (element) =>
          element.serviceName == message.serviceName &&
          element.serviceAvatar == message.serviceAvatar &&
          element.type == MessageType.loading,
    );
    if (loadingIndex == -1) {
      messages.insert(0, message);
    } else {
      messages.removeAt(loadingIndex);
      messages.insert(0, message);
    }
    update();
  }

  Future<void> onRetried(Message message) async {
    if (message.type != MessageType.error) return;

    final index = messages.indexWhere((element) => element == message);
    messages[index] = message.copyWith(type: MessageType.loading);
    update();

    await AppDatabase.instance.messagesDao.delete(message);

    final provider = await ServiceProviderManager.to.get(
      id: message.serviceId,
    );
    provider?.send(
      conversation: currentConversation!,
      message: message.requestMessage!,
    );
  }

  void onQuoted(Message message) {
    currentQuotedMessage = message;
    update();

    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
  }

  // clear current quote message
  void onCleared() {
    currentQuotedMessage = null;
    update();
  }

  void onAvatarClicked(Message message) {
    focusNode.unfocus();
    Get.toNamed(
      Routes.service,
      arguments: message.serviceId,
    );
  }

  Future<void> changeGroup(int index) async {
    conversations.clear();
    conversations.addAll(
      await AppDatabase.instance.conversationsDao.getAll(
        groupId: groups[currentGroupIndex].id,
      ),
    );

    homeDrawerControllers.clear();
    homeDrawerControllers.addAll(
      conversations.map(
        (e) => HomeDrawerController(e),
      ),
    );

    final conversationIndex = AppManager.to.get(
      key: currentConversationIndexHiveKey,
    );
    changeConversation(index: conversationIndex);
  }

  Future<Conversation?> changeConversation({int? index}) async {
    if (index == null || index >= conversations.length) {
      await _createConversation();
      index = conversations.length - 1;
    } else if (currentConversationIndex == index) {
      return currentConversation;
    }

    currentConversationIndex = index;

    messages.clear();
    final list = await AppDatabase.instance.messagesDao.get(
      conversationId: conversations[index].id,
    );
    messages.addAll(list);

    canFetchTop = list.length >= AppDatabase.defaultLimit;

    update();

    final providers = await ServiceProviderManager.to.getAll(
      group: groups[currentGroupIndex],
      conversation: currentConversation!,
    );
    for (final item in providers) {
      item.onInit(
        group: groups[currentGroupIndex],
        conversation: currentConversation!,
      );
    }

    return currentConversation;
  }

  Future<void> _createConversation({String? name}) async {
    final conversation = Conversation(
      id: AppUuid.value,
      name: name ?? '${'new_chat'.tr} ${conversations.length + 1}',
      groupId: groups[currentGroupIndex].id,
    );

    // create or replace
    await AppDatabase.instance.conversationsDao.create(
      conversation,
    );

    // id == null: create conversation
    await AppDatabase.instance.messagesDao.onCreate(
      conversationId: conversation.id,
    );

    conversations.add(conversation);
    homeDrawerControllers.add(
      HomeDrawerController(conversation),
    );
  }

  Future<void> updateConversation(
      {required String id, required String name}) async {
    final index = conversations.indexWhere((element) => element.id == id);

    final conversation = conversations[index].copyWith(
      name: name,
    );
    conversations[index] = conversation;
    // replace
    await AppDatabase.instance.conversationsDao.create(
      conversation,
    );

    update();
  }

  Future<Conversation> deleteConversation(int index) async {
    final Conversation conversation = conversations[index];

    conversations.removeAt(index);
    homeDrawerControllers.removeAt(index);
    await AppDatabase.instance.conversationsDao.delete(
      conversation.id,
    );
    await AppDatabase.instance.messagesDao.dropTable(
      conversationId: conversation.id,
    );

    if (currentConversationIndex == index) {
      AppManager.to.set(
        key: AppHiveKeys.currentConversationIndex,
        value: null,
      );
    }

    if (conversations.isEmpty) {
      changeGroup(0);
    } else if (index == conversations.length) {
      changeConversation(index: conversations.length - 1);
    } else {
      changeConversation(index: index);
    }
    return conversation;
  }

  @override
  Future<void> onEndScroll() async {
    if (currentConversation?.id == null) return;

    final list = await AppDatabase.instance.messagesDao.get(
      conversationId: currentConversation!.id,
      offset: messages.length,
    );
    messages.addAll(list);

    canFetchTop = list.length >= AppDatabase.defaultLimit;

    update();
  }

  @override
  Future<void> onTopScroll() async {}
}
