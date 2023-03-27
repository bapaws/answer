import 'package:answer/app/core/app/app_controller_mixin.dart';
import 'package:answer/app/data/models/request_parameter.dart';
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
  final parameters = <RequestParameter>[];

  final apiUrlFocusNode = FocusNode();
  final apiUrlTextEditingController = TextEditingController();
  final Map<String, TextEditingController> tokenControllers = {};
  final Map<String, FocusNode> focusNodes = {};

  final Map<String, TextEditingController> parameterControllers = {};

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
    parameters.addAll(ServiceProviderManager.instance.getParameters(
      vendorId: vendor!.id,
    ));
    if (vendor?.url != null) {
      apiUrlTextEditingController.text = vendor!.url!;
    }
    for (final item in tokens) {
      tokenControllers[item.id] = TextEditingController(
        text: item.value.isNotEmpty ? obscureText : '',
      );
      focusNodes[item.id] = FocusNode();
    }
    final first = tokens.firstOrNull;
    if (first?.value.isEmpty == true) {
      editing = true;
      focusNodes[first!.id]?.requestFocus();
    }

    for (final item in parameters) {
      parameterControllers[item.key!] = TextEditingController(
        text: item.value,
      );
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
      tokenControllers[token.id]?.text == obscureText;

  void onObscured(ServiceToken token) {
    if (isObscure(token) || editing) {
      tokenControllers[token.id]?.text = token.value;
    } else {
      tokenControllers[token.id]?.text = '••••••';
    }
    update();
  }

  void onEdited() {
    editing = true;
    for (final token in tokens) {
      tokenControllers[token.id]?.text = token.value;
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
      if (token.value != tokenControllers[token.id]?.text) {
        tokens[index] = token.copyWith(
          value: tokenControllers[token.id]?.text,
        );
        await ServiceProviderManager.instance.saveToken(tokens[index]);
      }
    }

    for (int index = 0; index < parameters.length; index++) {
      final parameter = parameters[index];
      if (parameter.value != parameterControllers[parameter.key]?.text) {
        parameters[index] = parameter.copyWith(
          value: parameterControllers[parameter.key]?.text,
        );
        await ServiceProviderManager.instance.saveParameter(parameters[index]);
      }
    }

    vendor?.editApiUrl = apiUrlTextEditingController.text;

    editing = false;

    update();

    await AppDatabase.instance.serviceVendorsDao.create(vendor!);

    AppToast.show(msg: 'saved_successfully'.tr);
  }
}
