import 'package:answer/app/core/app/app_view_mixin.dart';
import 'package:answer/app/views/app_cell.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/prompt_controller.dart';

class PromptView extends StatelessWidget with AppViewMixin<PromptController> {
  @override
  String? get title => 'prompt'.tr;

  const PromptView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'prompt'.tr,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      actions: [
        TextButton(
          onPressed: controller.onNew,
          child: Text(
            'new'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return _buildListView(context);
    // return Column(
    //   children: [
    //     Container(
    //       padding: const EdgeInsets.symmetric(
    //         vertical: 4,
    //         horizontal: 16,
    //       ),
    //       // height: 44,
    //       child: TextField(
    //         // enabled: enabled,
    //         // focusNode: focusNode,
    //         // controller: controller,
    //         cursorColor: Theme.of(context).focusColor,
    //         textAlignVertical: TextAlignVertical.center,
    //         // textInputAction: TextInputAction.send,
    //         cursorRadius: const Radius.circular(5),
    //         maxLines: null,
    //         keyboardType: TextInputType.multiline,
    //
    //         decoration: InputDecoration(
    //           prefixIcon: const Icon(
    //             Icons.search,
    //             size: 18,
    //           ),
    //           prefixIconColor: Theme.of(context).colorScheme.onSurface,
    //           prefixIconConstraints: const BoxConstraints.tightFor(
    //             width: 36,
    //             height: 36,
    //           ),
    //           border: InputBorder.none,
    //           isCollapsed: true,
    //           filled: true,
    //           fillColor: Theme.of(context).unselectedWidgetColor,
    //           hintText: 'search'.tr,
    //           contentPadding: const EdgeInsets.symmetric(
    //             vertical: 8,
    //             horizontal: 16,
    //           ),
    //           enabledBorder: OutlineInputBorder(
    //             borderRadius: const BorderRadius.all(
    //               Radius.circular(16),
    //             ),
    //             borderSide: BorderSide(
    //               color: Theme.of(context).scaffoldBackgroundColor,
    //               width: 1,
    //             ),
    //           ),
    //           focusedBorder: OutlineInputBorder(
    //             borderSide: BorderSide(
    //               color: Theme.of(context).scaffoldBackgroundColor,
    //               width: 1,
    //             ),
    //             borderRadius: const BorderRadius.all(
    //               Radius.circular(16),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     Expanded(
    //       child: _buildListView(context),
    //     ),
    //   ],
    // );
  }

  ListView _buildListView(BuildContext context) {
    return ListView.separated(
      itemCount: controller.prompts.length,
      itemBuilder: (context, index) {
        final prompt = controller.prompts[index];
        return AppCell(
          title: Text(prompt.title ?? ''),
          description: Text(
            prompt.content ?? '',
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
          ),
          trailing: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
                onPressed: () {
                  controller.onEdited(prompt);
                },
                icon: const Icon(Icons.edit_outlined),
                iconSize: 18,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
                onPressed: () {
                  controller.onDeleted(prompt);
                },
                icon: const Icon(Icons.delete_outline),
                iconSize: 18,
              ),
            ],
          ),
          onPressed: () {
            Get.back(result: prompt);
          },
          hiddenDivider: true,
        );
      },
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        thickness: 1,
      ),
    );
  }
}
