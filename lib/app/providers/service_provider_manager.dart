import 'package:answer/app/data/models/conversation.dart';
import 'package:answer/app/data/models/group.dart';
import 'package:answer/app/modules/home/controllers/home_controller.dart';
import 'package:answer/app/providers/open_ai/chat_gpt.dart';
import 'package:answer/app/providers/service_provider.dart';
import 'package:get/get.dart';

import '../data/db/app_database.dart';

class ServiceProviderManager extends GetxController {
  static ServiceProviderManager to = Get.find();

  late final _providers = <ServiceProvider>[
    ChatGpt(
      onReceived: HomeController.to.onReceived,
    ),
    // ChatGPTUnofficialProxyAPI no longer works
    // ChatGptApi(
    //   onReceived: HomeController.to.onReceived,
    // ),
  ];

  @override
  Future<void> onInit() async {
    for (final item in _providers) {
      await _updateProvider(item);
    }
    super.onInit();
  }

  Future<void> _updateProvider(ServiceProvider? provider) async {
    if (provider == null) return;

    final map = await AppDatabase.instance.serviceProvidersDao.get(
      id: provider.id,
    );
    if (map != null) {
      provider.name = map['name'];
      provider.avatar = map['avatar'];
      provider.officialUrl = map['official_url'];
      provider.editApiUrl = map['edit_api_url'];
      provider.help = map['help'];
      provider.helpUrl = map['help_url'];
      provider.block = map['block'] == 1 ? true : false;
    }

    final tokens = await AppDatabase.instance.serviceTokensDao.getAll(
      serviceId: provider.id,
    );
    if (tokens.isNotEmpty) {
      provider.tokens.clear();
      provider.tokens.addAll(tokens);
    }
  }

  Future<ServiceProvider?> get({String? id}) async {
    final provider = _providers.firstWhereOrNull(
      (element) => element.id == id,
    );
    await _updateProvider(provider);
    return provider;
  }

  Future<List<ServiceProvider>> getAll({
    required Group group,
    required Conversation conversation,
  }) async {
    final List<ServiceProvider> list = [];
    for (final item in _providers) {
      if (item.groupId == group.id && !item.block) {
        list.add(item);
        item.onInit(group: group, conversation: conversation);
      }
    }
    return list;
  }

  Future<void> block(ServiceProvider? provider, bool isBlocked) async {
    if (provider == null) return;

    provider.block = isBlocked;

    // replace block value
    await AppDatabase.instance.serviceProvidersDao.create(provider);
  }
}
