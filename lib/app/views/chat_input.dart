import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatInput extends StatelessWidget {
  final bool? enabled;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController controller;
  final FocusNode focusNode;

  const ChatInput({
    Key? key,
    required this.controller,
    this.onSubmitted,
    this.enabled,
    required this.focusNode,
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
        children: [
          Expanded(
            child: TextField(
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
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              onSubmitted?.call(controller.text);
              controller.clear();
            },
            constraints: const BoxConstraints.tightFor(
              width: 36,
              height: 32,
            ),
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
