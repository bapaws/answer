import 'package:answer/app/providers/open_ai/chat_gpt.dart';
import 'package:answer/app/routes/app_pages.dart';
import 'package:answer/app/views/app_cell.dart';
import 'package:answer/app/views/app_section.dart';
import 'package:answer/app/views/chat_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app/app_view_mixin.dart';
import '../controllers/service_controller.dart';
import 'service_info.dart';

class ServiceView extends StatelessWidget with AppViewMixin<ServiceController> {
  static const titleWidth = 80.0;
  const ServiceView({
    Key? key,
  }) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      actions: controller.editing
          ? [
              TextButton(
                onPressed: controller.onSaved,
                child: Text(
                  'save'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ]
          : [
              IconButton(
                onPressed: controller.onEdited,
                icon: const Icon(Icons.edit),
              ),
            ],
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    if (controller.provider == null) return Container();

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        ServiceInfo(
          provider: controller.provider!,
        ),
        if (controller.provider?.desc != null)
          AppCell(
            title: Text(
              controller.provider!.desc!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        const SizedBox(
          height: 8,
        ),
        AppCell.switchTile(
          title: SizedBox(
            width: titleWidth,
            child: Text(
              'block'.tr,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          initialValue: controller.provider?.block ?? false,
          hiddenDivider: true,
          maxHeight: 54,
          onToggle: (value) {
            controller.onBlocked(value);
          },
        ),
        const SizedBox(
          height: 8,
        ),
        if (controller.provider is ChatGpt)
          AppCell.textFieldTile(
            title: SizedBox(
              width: 80,
              child: Text(
                'model'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            controller: controller.modelTextEditing,
            enabled: controller.editing,
            hintText: (controller.provider as ChatGpt).model,
            hiddenDivider: true,
          ),
        const SizedBox(
          height: 8,
        ),
        AppSection(title: Text('vendor'.tr)),
        AppCell.navigation(
          leading: ChatAvatar(
            path: controller.vendor?.avatar,
          ),
          title: SizedBox(
            width: 80,
            child: Text(
              controller.vendor?.name ?? '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          hiddenDivider: true,
          onPressed: () {
            Get.toNamed(
              Routes.vendor,
              arguments: controller.vendor?.id,
            );
          },
        ),
      ],
    );
  }
}
