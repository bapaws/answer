import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/message.dart';

class ChatInput extends StatelessWidget {
  final bool? enabled;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController controller;
  final FocusNode focusNode;

  final Message? quoteMessage;
  final VoidCallback? onCleared;

  const ChatInput({
    Key? key,
    required this.controller,
    this.onSubmitted,
    this.enabled,
    required this.focusNode,
    this.quoteMessage,
    this.onCleared,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        color: Theme.of(context).appBarTheme.backgroundColor,
      ),
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 8,
        top: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: quoteMessage == null
                ? _buildTextField(context)
                : Column(
                    children: [
                      _buildQuote(context),
                      const SizedBox(
                        height: 4,
                      ),
                      _buildTextField(context),
                    ],
                  ),
          ),
          const SizedBox(
            width: 8,
          ),
          CircleAvatar(
            radius: 17.5,
            backgroundColor: Theme.of(context).primaryColorDark,
            child: IconButton(
              // padding: EdgeInsets.zero,
              onPressed: () {
                onSubmitted?.call(controller.text);
                controller.clear();
              },
              color: Theme.of(context).cardColor,
              icon: const Icon(
                Icons.north,
                size: 18,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuote(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 4,
        // left: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).unselectedWidgetColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 8,
              right: 4,
            ),
            child: Icon(
              Icons.format_quote_rounded,
              size: 16,
            ),
          ),
          Expanded(
            child: Text(
              quoteMessage?.content?.replaceAll('\n', '') ?? '',
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 8),
            iconSize: 15,
            constraints: const BoxConstraints.tightFor(
              width: 32,
            ),
            onPressed: onCleared,
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
    );
  }

  TextField _buildTextField(BuildContext context) {
    return TextField(
      enabled: enabled,
      focusNode: focusNode,
      controller: controller,
      cursorColor: Theme.of(context).focusColor,
      textAlignVertical: TextAlignVertical.center,
      // textInputAction: TextInputAction.send,
      cursorRadius: const Radius.circular(5),
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        border: InputBorder.none,
        isCollapsed: true,
        filled: true,
        fillColor: Theme.of(context).unselectedWidgetColor,
        hintText: 'typing_a_message'.tr,
        contentPadding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          borderSide: BorderSide(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
        ),
      ),
    );
  }
}
