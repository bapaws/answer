import 'package:answer/app/data/models/conversation.dart';
import 'package:answer/app/modules/home/controllers/home_controller.dart';
import 'package:answer/app/views/chat_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app/app_toast.dart';

class HomeDrawer extends GetView<HomeController> {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: GetBuilder<HomeController>(
        builder: (controller) => ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: OutlinedButton.icon(
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
                ),
                label: Text(
                  'new_chat'.tr,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            for (int index = 0;
                index < controller.conversations.length;
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
    final Conversation conversation = controller.conversations[index];
    final isCurrent = controller.currentConversationIndex == index;
    return GestureDetector(
      onTap: () {
        controller.changeConversation(index: index);

        Future.delayed(const Duration(milliseconds: 200), () {
          Scaffold.of(context).openDrawer();
          Scaffold.of(context).openEndDrawer();
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          color: isCurrent
              ? Theme.of(context).primaryColorDark
              : Theme.of(context).cardColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                conversation.displayName ?? 'new_chat'.tr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isCurrent ? Colors.white : null,
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
                controller.toConversation(
                  conversation: conversation,
                );
              },
              icon: Icon(
                Icons.more_horiz,
                color: isCurrent ? Colors.white : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
