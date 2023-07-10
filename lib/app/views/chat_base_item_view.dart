import 'package:answer/app/core/app/app_toast.dart';
import 'package:answer/app/views/chat_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../data/models/message.dart';

abstract class ChatBaseItemView extends StatelessWidget {
  static const avatarWidth = 36.0;

  final Message message;
  final ValueChanged<Message>? onRetried;
  final ValueChanged<Message>? onAvatarClicked;
  final ValueChanged<Message>? onQuoted;

  const ChatBaseItemView({
    Key? key,
    required this.message,
    this.onRetried,
    required this.onAvatarClicked,
    this.onQuoted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        child: message.fromType == MessageFromType.receive
            ? buildReceiveRow(context)
            : buildSendRow(context),
      );

  Widget buildContent(BuildContext context);

  Widget buildReceiveRow(BuildContext context) {
    final container = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).unselectedWidgetColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: buildContent(context),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatar(context),
        const SizedBox(
          width: 8,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => onAvatarClicked?.call(message),
                child: Text(
                  message.serviceName ?? '-',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              message.type == MessageType.error
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: container,
                        ),
                        IconButton(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 0,
                            right: 16,
                            bottom: 16,
                          ),
                          onPressed: () => onRetried?.call(message),
                          icon: Icon(
                            Icons.info,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    )
                  : container,
              if ((message.type == MessageType.text &&
                      message.content != null) ||
                  message.type == MessageType.image)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildButton(
                      context: context,
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(
                            text: message.content ?? "",
                          ),
                        );
                        AppToast.show(msg: 'copied'.tr);
                      },
                      icon: const Icon(Icons.copy),
                    ),
                    buildButton(
                      context: context,
                      onPressed: () {
                        if (message.type == MessageType.text) {
                          Share.share(
                            message.content!,
                            subject: message.serviceName,
                          );
                        }
                      },
                      icon: const Icon(Icons.share),
                    ),
                    buildButton(
                      context: context,
                      onPressed: () {
                        onQuoted?.call(message);
                      },
                      icon: const Icon(
                        Icons.format_quote_rounded,
                        size: 20,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(
          width: avatarWidth,
        ),
      ],
    );
  }

  Widget buildButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required Widget icon,
  }) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        width: 32,
        height: 32,
      ),
      iconSize: 16,
      onPressed: onPressed,
      icon: icon,
    );
  }

  Widget buildSendRow(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 8 + avatarWidth,
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: buildContent(context),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          _buildAvatar(context),
        ],
      );

  Widget _buildAvatar(BuildContext context) => GestureDetector(
        onTap: () => onAvatarClicked?.call(message),
        child: ChatAvatar(
          path: message.serviceAvatar ?? 'assets/images/logo-white.png',
          width: avatarWidth,
          height: avatarWidth,
          radius: const Radius.circular(8),
        ),
      );
}
