import 'package:answer/app/core/app/app_toast.dart';
import 'package:answer/app/data/db/app_database.dart';
import 'package:answer/app/providers/service_provider_manager.dart';
import 'package:answer/app/providers/service_vendor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app/app_controller_mixin.dart';
import '../../../providers/service_provider.dart';

class ServiceController extends GetxController with AppControllerMixin {
  late final String serviceId = Get.arguments ?? Get.parameters['service_id'];
  ServiceProvider? provider;

  ServiceVendor? vendor;

  late final modelFocusNode = FocusNode();
  late final modelTextEditing = TextEditingController(
    text: provider?.model,
  );

  bool editing = false;

  @override
  Future<void> onReady() async {
    provider = await ServiceProviderManager.instance.get(
      id: serviceId,
    );
    vendor = ServiceProviderManager.instance.vendors.firstWhereOrNull(
      (element) => element.id == provider?.vendorId,
    );
    update();

    super.onReady();
  }

  void onEdited() {
    editing = true;
    update();
    // delay is working
    Future.delayed(const Duration(milliseconds: 100), () {
      modelFocusNode.requestFocus();
    });
  }

  Future<void> onSaved() async {
    if (provider == null && vendor == null) return;

    if (modelTextEditing.text != provider?.model) {
      provider = provider?.copyWith(model: modelTextEditing.text);
      await AppDatabase.instance.serviceProvidersDao.create(provider!);
    }

    editing = false;

    update();

    AppToast.show(msg: 'saved_successfully'.tr);
  }

  Future<void> onBlocked(bool value) async {
    await ServiceProviderManager.instance.block(provider, value);
    update();
  }
}
