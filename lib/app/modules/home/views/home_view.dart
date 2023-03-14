import 'package:answer/app/core/app/app_toast.dart';
import 'package:answer/app/core/app/app_view_mixin.dart';
import 'package:answer/app/modules/home/views/home_drawer.dart';
import 'package:answer/app/views/chat_input.dart';
import 'package:answer/app/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget with AppViewMixin<HomeController> {
  @override
  bool get bottomSafeArea => true;

  @override
  Color? get systemNavigationBarColor =>
      Theme.of(context).appBarTheme.backgroundColor;

  const HomeView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          height: 2,
        ),
      ),
      elevation: 0,
      title: Text(
        controller.currentConversation?.displayName ?? 'new_chat'.tr,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      centerTitle: true,
      titleSpacing: 0,
      actions: [
        IconButton(
          onPressed: () async {
            final conv = await controller.changeConversation();
            if (conv?.displayName != null) {
              AppToast.show(
                msg: 'new_chat_created'.trParams(
                  {'name': conv!.displayName!},
                ),
              );
            }
          },
          icon: const Icon(
            Icons.add,
            size: 25,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) => Column(
        children: [
          Expanded(
            child: ChatView(
              messages: controller.messages,
              controller: controller.scroll,
              onRetried: controller.onRetried,
              onAvatarClicked: controller.onAvatarClicked,
            ),
          ),
          ChatInput(
            focusNode: controller.focusNode,
            controller: controller.textEditing,
            onSubmitted: controller.onSubmitted,
          ),
        ],
      );

  @override
  Widget? buildDrawer() => const HomeDrawer();
}
