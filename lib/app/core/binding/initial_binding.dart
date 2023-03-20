import 'package:answer/app/providers/service_provider_manager.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<ServiceProviderManager>(
    //   () => ServiceProviderManager(),
    // );
  }
}
