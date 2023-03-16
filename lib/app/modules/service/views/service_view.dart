import 'package:answer/app/views/app_cell.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/app/app_view_mixin.dart';
import '../controllers/service_controller.dart';
import 'service_info.dart';
import 'service_token_item_view.dart';

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
        // const SizedBox(
        //   height: 8,
        // ),
        // AppCell.switchTile(
        //   title: SizedBox(
        //     width: titleWidth,
        //     child: Text(
        //       'Block',
        //       style: Theme.of(context).textTheme.titleMedium,
        //     ),
        //   ),
        //   initialValue: controller.provider?.block ?? false,
        //   hiddenDivider: true,
        //   maxHeight: 54,
        //   onToggle: (value) {
        //     controller.onBlocked(value);
        //   },
        // ),
        const SizedBox(
          height: 8,
        ),
        // if (controller.provider?.officialUrl != null)
        //   AppCell(
        //     title: SizedBox(
        //       width: titleWidth,
        //       child: Text(
        //         'Base URL',
        //         style: Theme.of(context).textTheme.titleMedium,
        //       ),
        //     ),
        //     detail: Text(controller.provider!.officialUrl!),
        //   ),
        if (controller.provider?.apiUrl != null)
          AppCell(
            title: SizedBox(
              width: 80,
              child: Text(
                'API URL',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            detail: Expanded(
              child: TextField(
                minLines: 1,
                maxLines: 1,
                autocorrect: false,
                enabled: controller.editing,
                focusNode: controller.apiUrlFocusNode,
                controller: controller.apiUrlTextEditingController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration.collapsed(
                  hintText: 'type_your_tokens'.trParams({'name': 'API URL'}),
                ),
                textInputAction: controller.provider!.tokens.isEmpty
                    ? TextInputAction.done
                    : TextInputAction.next,
              ),
            ),
          ),
        // AppCell(
        //   title: SizedBox(
        //     width: titleWidth,
        //     child: Text(
        //       'API URL',
        //       style: Theme.of(context).textTheme.titleMedium,
        //     ),
        //   ),
        //   detail: Text(controller.provider!.apiUrl!),
        //   hiddenDivider: true,
        // ),
        const SizedBox(
          height: 8,
        ),
        for (final item in controller.provider!.tokens)
          ServiceTokenItemView(
            item: item,
            textEditingController: controller.textEditingControllers[item.id]!,
            focusNode: controller.focusNodes[item.id]!,
            onObscured: () {
              controller.onObscured(item);
            },
            enabled: controller.editing,
            obscured: controller.isObscure(item),
            textInputAction: item == controller.provider!.tokens.last
                ? TextInputAction.done
                : TextInputAction.next,
          ),
        const SizedBox(
          height: 8,
        ),
        if (controller.provider?.helpUrl?.isNotEmpty == true)
          AppCell.navigation(
            title: SizedBox(
              width: titleWidth,
              child: Text(
                'Get Help',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            hiddenDivider: true,
            onPressed: () {
              launchUrlString(controller.provider!.helpUrl!);
            },
          ),
      ],
    );
  }
}
