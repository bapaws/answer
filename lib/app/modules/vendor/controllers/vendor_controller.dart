import 'package:answer/app/core/app/app_controller_mixin.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app/app_toast.dart';
import '../../../data/db/app_database.dart';
import '../../../data/models/service_token.dart';
import '../../../providers/service_provider_manager.dart';
import '../../../providers/service_vendor.dart';

class VendorController extends GetxController with AppControllerMixin {
  String get vendorId => Get.arguments;

  ServiceVendor? vendor;

  List<ServiceToken> tokens = [];

  final apiUrlFocusNode = FocusNode();
  final apiUrlTextEditingController = TextEditingController();
  final Map<String, TextEditingController> textEditingControllers = {};
  final Map<String, FocusNode> focusNodes = {};

  static const obscureText = '••••••';

  bool editing = false;

  @override
  Future<void> onReady() async {
    vendor = ServiceProviderManager.instance.vendors.firstWhereOrNull(
      (element) => element.id == vendorId,
    );
    tokens.addAll(ServiceProviderManager.instance.getTokens(
      vendorId: vendor!.id,
    ));
    if (vendor?.url != null) {
      apiUrlTextEditingController.text = vendor!.url!;
    }
    for (final item in tokens) {
      textEditingControllers[item.id] = TextEditingController(
        text: item.value.isNotEmpty ? obscureText : '',
      );
      focusNodes[item.id] = FocusNode();
    }
    final first = tokens.firstOrNull;
    if (first?.value.isEmpty == true) {
      focusNodes[first!.id]?.requestFocus();
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
    for (final token in tokens) {
      textEditingControllers[token.id]?.text = token.value;
    }
    update();
    // delay is working
    Future.delayed(const Duration(milliseconds: 100), () {
      apiUrlFocusNode.requestFocus();
    });
  }

  Future<void> onSaved() async {
    if (vendor == null) return;

    for (int index = 0; index < tokens.length; index++) {
      final token = tokens[index];
      tokens[index] = token.copyWith(
        value: textEditingControllers[token.id]?.text,
      );
      await AppDatabase.instance.serviceTokensDao.create(
        tokens[index],
      );
    }
    vendor?.editApiUrl = apiUrlTextEditingController.text;

    editing = false;

    update();

    await AppDatabase.instance.serviceVendorsDao.create(vendor!);

    AppToast.show(msg: 'saved_successfully'.tr);
  }
}
