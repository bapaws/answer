import 'package:answer/app/core/app/app_progress_hud.dart';
import 'package:answer/app/modules/home/controllers/home_controller.dart';
import 'package:answer/app/modules/home/controllers/home_drawer_controller.dart';
import 'package:answer/app/views/chat_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeDrawer extends GetView<HomeController> {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: GetBuilder<HomeController>(
        builder: (controller) => ListView(
          children: [
            _buildItemView(
              context: context,
              content: Row(
                children: [
                  const ChatAvatar(
                    path: 'assets/images/logo-white.png',
                    radius: Radius.circular(8),
                    width: 54,
                    height: 54,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'app_name'.tr,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'slogan'.tr,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildItemView(
              context: context,
              content: Text('conversations'.tr),
              color: Theme.of(context).dividerColor,
            ),
            for (int index = 0;
                index < controller.homeDrawerControllers.length;
                index++)
              _buildConversationItemView(context, index),
          ],
        ),
      ),
    );
  }

  Widget _buildItemView({
    required BuildContext context,
    required Widget content,
    EdgeInsetsGeometry? padding,
    Color? color,
  }) =>
      Container(
        padding: padding ??
            const EdgeInsets.only(
              left: 16,
              top: 8,
              bottom: 8,
              right: 8,
            ),
        color: color,
        child: content,
      );

  Widget _buildConversationItemView(
    BuildContext context,
    int index,
  ) {
    final HomeDrawerController homeDrawerController =
        controller.homeDrawerControllers[index];
    return GestureDetector(
      onTap: () {
        Scaffold.of(context).openDrawer();
        Scaffold.of(context).openEndDrawer();
        controller.changeConversation(index: index);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: Theme.of(context).textTheme.titleMedium,
                focusNode: homeDrawerController.focusNode,
                controller: homeDrawerController.textEditingController,
                onSubmitted: (value) {
                  homeDrawerController.editing = false;

                  controller.updateConversation(
                    id: homeDrawerController.conversation.id,
                    name: value,
                  );
                },
                decoration: InputDecoration(
                  hintText: '',
                  isCollapsed: true,
                  border: InputBorder.none,
                  enabled: homeDrawerController.editing,
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: 28,
                height: 28,
              ),
              iconSize: 18,
              onPressed: () {
                homeDrawerController.editing = true;
                controller.update();

                Future.delayed(const Duration(milliseconds: 100), () {
                  homeDrawerController.focusNode.requestFocus();
                });
              },
              icon: const Icon(
                Icons.edit_outlined,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: 28,
                height: 28,
              ),
              iconSize: 18,
              onPressed: () async {
                AppProgressHud.show();
                await controller.deleteConversation(index);
                AppProgressHud.dismiss();
              },
              icon: const Icon(
                Icons.delete_outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
