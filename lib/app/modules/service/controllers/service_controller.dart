import 'package:answer/app/data/db/app_database.dart';
import 'package:answer/app/data/models/service_token.dart';
import 'package:answer/app/providers/service_provider_manager.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app/app_controller_mixin.dart';
import '../../../providers/service_provider.dart';

class ServiceController extends GetxController with AppControllerMixin {
  late final String serviceId = Get.arguments;
  ServiceProvider? provider;

  final apiUrlFocusNode = FocusNode();
  final apiUrlTextEditingController = TextEditingController();
  final Map<String, TextEditingController> textEditingControllers = {};
  final Map<String, FocusNode> focusNodes = {};

  static const obscureText = '••••••';

  bool editing = false;

  @override
  Future<void> onReady() async {
    provider = await ServiceProviderManager.to.get(
      id: serviceId,
    );
    if (provider?.url != null) {
      apiUrlTextEditingController.text = provider!.url!;
    }
    if (provider?.tokens != null) {
      for (final item in provider!.tokens) {
        textEditingControllers[item.id] = TextEditingController(
          text: item.value.isNotEmpty ? obscureText : '',
        );
        focusNodes[item.id] = FocusNode();
      }
      final first = provider?.tokens.firstOrNull;
      if (first?.value.isEmpty == true) {
        focusNodes[first!.id]?.requestFocus();
      }
    }
    update();

    super.onReady();
  }

  @override
  void onClose() {
    for (final item in focusNodes.values) {
      item.unfocus();
    }
    super.onClose();
  }

  bool isObscure(ServiceToken token) =>
      textEditingControllers[token.id]?.text == obscureText;

  void onObscured(ServiceToken token) {
    if (isObscure(token) || editing) {
      textEditingControllers[token.id]?.text = token.value;
    } else {
      textEditingControllers[token.id]?.text = '••••••';
    }
    update();
  }

  void onEdited() {
    editing = true;
    for (final token in provider!.tokens) {
      textEditingControllers[token.id]?.text = token.value;
    }
    update();
    // delay is working
    Future.delayed(const Duration(milliseconds: 100), () {
      apiUrlFocusNode.requestFocus();
    });
  }

  void onReset() {
    if (provider == null) return;
  }

  Future<void> onSaved() async {
    if (provider == null) return;

    for (int index = 0; index < provider!.tokens.length; index++) {
      final token = provider!.tokens[index];
      provider?.tokens[index] = token.copyWith(
        value: textEditingControllers[token.id]?.text,
      );
    }
    provider?.editApiUrl = apiUrlTextEditingController.text;

    editing = false;

    update();

    await AppDatabase.instance.serviceProvidersDao.create(provider!);
  }

  Future<void> onBlocked(bool value) async {
    await ServiceProviderManager.to.block(provider, value);
    update();
  }
}
