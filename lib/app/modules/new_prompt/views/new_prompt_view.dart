import 'package:answer/app/core/app/app_view_mixin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/new_prompt_controller.dart';

class NewPromptView extends StatelessWidget
    with AppViewMixin<NewPromptController> {
  const NewPromptView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: Get.back,
        icon: const Icon(Icons.close),
      ),
      title: Text('new'.tr),
      actions: [
        IconButton(
          onPressed: controller.onCreated,
          icon: const Icon(Icons.check),
        )
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: 16,
          ),
          color: Theme.of(context).cardColor,
          height: 54,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  controller: controller.titleTextEditing,
                  decoration: InputDecoration.collapsed(
                    hintText: 'typing_title'.tr,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.titleTextEditing.clear();
                },
                icon: const Icon(Icons.clear),
                iconSize: 18,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          color: Theme.of(context).cardColor,
          height: 200,
          child: TextField(
            controller: controller.contentTextEditing,
            decoration: InputDecoration.collapsed(
              hintText: 'typing_content'.tr,
            ),
            maxLines: 20,
          ),
        ),
      ],
    );
  }
}
