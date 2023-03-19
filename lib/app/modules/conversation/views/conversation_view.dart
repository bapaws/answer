import 'package:answer/app/core/app/app_progress_hud.dart';
import 'package:answer/app/core/app/app_view_mixin.dart';
import 'package:answer/app/providers/service_provider.dart';
import 'package:answer/app/views/app_cell.dart';
import 'package:answer/app/views/app_section.dart';
import 'package:answer/app/views/chat_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/conversation_controller.dart';

class ConversationView extends StatelessWidget
    with AppViewMixin<ConversationController> {
  const ConversationView({Key? key}) : super(key: key);

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
    return ListView(
      children: [
        AppCell(
          title: SizedBox(
            width: 120,
            child: Text('conversation_name'.tr),
          ),
          detail: TextField(
            minLines: 1,
            maxLines: 3,
            enabled: controller.editing,
            controller: controller.nameTextEditing,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: const InputDecoration.collapsed(
              hintText: '',
            ),
            // onSubmitted: onSubmitted,
            textInputAction: TextInputAction.next,
          ),
          hiddenDivider: true,
        ),
        const SizedBox(
          height: 16,
        ),
        AppCell.switchTile(
          title: SizedBox(
            width: 120,
            child: Text('auto_quote'.tr),
          ),
          initialValue: controller.conversation.autoQuote != 0,
          maxHeight: 54,
          onToggle: controller.onQuoted,
        ),
        AppCell.textFieldTile(
          title: SizedBox(
            width: 120,
            child: Text('max_tokens'.tr),
          ),
          enabled: controller.editing,
          controller: controller.maxTokensTextEditing,
        ),
        AppCell.textFieldTile(
          title: SizedBox(
            width: 120,
            child: Text('timeout'.tr),
          ),
          enabled: controller.editing,
          controller: controller.timeoutTextEditing,
          hiddenDivider: true,
        ),
        const SizedBox(
          height: 16,
        ),
        AppCell.navigation(
          title: SizedBox(
            width: 120,
            child: Text('system_role'.tr),
          ),
          detail: Text(controller.prompt?.title ?? ''),
          hiddenDivider: true,
          onPressed: controller.onPrompted,
        ),
        AppSection(title: Text('service'.tr)),
        ..._buildProviders(context),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: ElevatedButton(
            onPressed: () async {
              AppProgressHud.show();
              await controller.onDeleted();
              AppProgressHud.dismiss();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              shadowColor: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'delete'.tr,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildProviders(BuildContext context) {
    final List<Widget> items = [];
    for (final item in controller.providers) {
      items.add(_buildServiceProvider(
        context,
        item,
      ));
      items.add(const SizedBox(
        height: 1,
      ));
    }
    return items;
  }

  Widget _buildServiceProvider(
    BuildContext context,
    ServiceProvider serviceProvider,
  ) {
    return AppCell.navigation(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      maxHeight: 54,
      leading: ChatAvatar(
        path: serviceProvider.avatar,
        width: 36,
        height: 36,
        radius: const Radius.circular(8),
      ),
      title: Text(serviceProvider.name),
      detail: serviceProvider.block
          ? Align(
              alignment: Alignment.centerRight,
              child: Text('blocked'.tr),
            )
          : null,
      hiddenDivider: true,
      onPressed: () {
        Get.toNamed(
          Routes.service,
          arguments: serviceProvider.id,
        );
      },
    );
  }
}
