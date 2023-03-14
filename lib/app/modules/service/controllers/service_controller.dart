import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:answer/app/data/db/app_database.dart';
import 'package:answer/app/data/models/service_token.dart';
import 'package:answer/app/providers/service_provider_manager.dart';
import 'package:get/get.dart';

import '../../../core/app/app_controller_mixin.dart';
import '../../../providers/service_provider.dart';

class ServiceController extends GetxController with AppControllerMixin {
  late final String serviceId = Get.arguments;
  ServiceProvider? provider;

  final apiUrlTextEditingController = TextEditingController();
  final Map<String, TextEditingController> textEditingControllers = {};
  final Map<String, FocusNode> focusNodes = {};

  static const obscureText = '••••••';

  @override
  Future<void> onReady() async {
    provider = await ServiceProviderManager.to.get(
      id: serviceId,
    );
    if (provider?.apiUrl != null) {
      apiUrlTextEditingController.text = provider!.apiUrl!;
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
    if (isObscure(token)) {
      textEditingControllers[token.id]?.text = token.value;
    } else {
      textEditingControllers[token.id]?.text = '••••••';
    }
    update();
  }

  Future<void> onBlocked(bool value) async {
    await ServiceProviderManager.to.block(provider, value);
    update();
  }

  Future<void> onApiUrlSubmitted(ServiceToken token, String value) async {
    final index = provider?.tokens.indexWhere(
      (element) => element.id == token.id,
    );
    if (index == null || index == -1) return;

    final newToken = token.copyWith(value: value);
    provider?.tokens[index] = newToken;
    update();

    await AppDatabase.instance.serviceTokensDao.create(newToken);
  }

  Future<void> onTokenSubmitted(ServiceToken token, String value) async {
    final index = provider?.tokens.indexWhere(
      (element) => element.id == token.id,
    );
    if (index == null || index == -1) return;

    final newToken = token.copyWith(value: value);
    provider?.tokens[index] = newToken;
    update();

    await AppDatabase.instance.serviceTokensDao.create(newToken);
  }
}
