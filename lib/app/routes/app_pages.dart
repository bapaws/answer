import 'package:get/get.dart';

import '../modules/conversation/bindings/conversation_binding.dart';
import '../modules/conversation/views/conversation_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/new_prompt/bindings/new_prompt_binding.dart';
import '../modules/new_prompt/views/new_prompt_view.dart';
import '../modules/prompt/bindings/prompt_binding.dart';
import '../modules/prompt/views/prompt_view.dart';
import '../modules/service/bindings/service_binding.dart';
import '../modules/service/views/service_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/vendor/bindings/vendor_binding.dart';
import '../modules/vendor/views/vendor_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.service,
      page: () => const ServiceView(),
      binding: ServiceBinding(),
    ),
    GetPage(
      name: _Paths.conversation,
      page: () => const ConversationView(),
      binding: ConversationBinding(),
    ),
    GetPage(
      name: _Paths.prompt,
      page: () => const PromptView(),
      binding: PromptBinding(),
    ),
    GetPage(
      name: _Paths.newPrompt,
      page: () => const NewPromptView(),
      binding: NewPromptBinding(),
      fullscreenDialog: true,
    ),
    GetPage(
      name: _Paths.vendor,
      page: () => const VendorView(),
      binding: VendorBinding(),
    ),
  ];
}
