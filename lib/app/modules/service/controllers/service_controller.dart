import 'package:answer/app/core/app/app_toast.dart';
import 'package:answer/app/data/db/app_database.dart';
import 'package:answer/app/data/models/service_token.dart';
import 'package:answer/app/providers/service_provider_manager.dart';
import 'package:answer/app/providers/service_vendor.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app/app_controller_mixin.dart';
import '../../../providers/service_provider.dart';

class ServiceController extends GetxController with AppControllerMixin {
  late final String serviceId = Get.arguments ?? Get.parameters['service_id'];
  ServiceProvider? provider;

  ServiceVendor? vendor;

  final apiUrlFocusNode = FocusNode();
  final apiUrlTextEditingController = TextEditingController();
  final Map<String, TextEditingController> textEditingControllers = {};
  final Map<String, FocusNode> focusNodes = {};

  static const obscureText = '••••••';

  bool editing = false;

  @override
  Future<void> onReady() async {
    provider = await ServiceProviderManager.instance.get(
      id: serviceId,
    );
    vendor = ServiceProviderManager.instance.vendors.firstWhereOrNull(
      (element) => element.id == provider?.vendorId,
    );
    if (vendor?.url != null) {
      apiUrlTextEditingController.text = vendor!.url!;
    }
    if (vendor?.tokens != null) {
      for (final item in vendor!.tokens) {
        textEditingControllers[item.id] = TextEditingController(
          text: item.value.isNotEmpty ? obscureText : '',
        );
        focusNodes[item.id] = FocusNode();
      }
      final first = vendor?.tokens.firstOrNull;
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
    for (final token in vendor!.tokens) {
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

    for (int index = 0; index < vendor!.tokens.length; index++) {
      final token = vendor!.tokens[index];
      vendor?.tokens[index] = token.copyWith(
        value: textEditingControllers[token.id]?.text,
      );
    }
    vendor?.editApiUrl = apiUrlTextEditingController.text;

    editing = false;

    update();

    await AppDatabase.instance.serviceVendorsDao.create(vendor!);

    AppToast.show(msg: 'saved_successfully'.tr);
  }

  Future<void> onBlocked(bool value) async {
    await ServiceProviderManager.instance.block(provider, value);
    update();
  }
}
