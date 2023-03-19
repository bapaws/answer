import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/service_token.dart';
import '../../../views/app_cell.dart';

class ServiceTokenItemView extends StatelessWidget {
  const ServiceTokenItemView({
    super.key,
    required this.item,
    required this.enabled,
    required this.textEditingController,
    required this.onObscured,
    required this.obscured,
    this.onSubmitted,
    required this.focusNode,
    this.textInputAction,
  });

  final ServiceToken item;
  final bool enabled;
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final VoidCallback onObscured;
  final bool obscured;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return AppCell(
      title: SizedBox(
        width: 80,
        child: Text(
          item.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      detail: TextField(
        controller: textEditingController,
        focusNode: focusNode,
        minLines: 1,
        maxLines: 3,
        enabled: enabled,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration.collapsed(
          hintText: 'type_your_tokens'.trParams({'name': item.name}),
        ),
        onSubmitted: onSubmitted,
        textInputAction: textInputAction ?? TextInputAction.done,
      ),
      trailing: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onObscured,
        icon: obscured
            ? const Icon(Icons.visibility_off)
            : const Icon(Icons.visibility),
      ),
    );
  }
}
