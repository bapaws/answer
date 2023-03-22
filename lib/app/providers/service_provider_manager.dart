import 'package:answer/app/data/models/conversation.dart';
import 'package:answer/app/data/models/group.dart';
import 'package:answer/app/modules/home/controllers/home_controller.dart';
import 'package:answer/app/providers/open_ai/chat_gpt_3.dart';
import 'package:answer/app/providers/service_provider.dart';
import 'package:answer/app/providers/service_vendor.dart';
import 'package:get/get.dart';

import '../core/app/app_hive_keys.dart';
import '../core/app/app_manager.dart';
import '../data/db/app_database.dart';
import '../data/db/app_uuid.dart';
import '../data/models/message.dart';
import '../data/models/service_token.dart';
import 'open_ai/chat_gpt_4.dart';

class ServiceProviderManager extends GetxController {
  static final instance = ServiceProviderManager._internal();
  ServiceProviderManager._internal();

  late final providers = <ServiceProvider>[
    ChatGpt3(),
    ChatGpt4(),
    // ChatGPTUnofficialProxyAPI no longer works
    // ChatGptApi(
    //   onReceived: HomeController.to.onReceived,
    // ),
  ];

  late final vendors = <ServiceVendor>[];

  late final tokens = <ServiceToken>[];

  static Future<void> initialize() async {
    for (final item in instance.providers) {
      await instance._updateProvider(item);
    }
    instance.vendors.addAll(
      await AppDatabase.instance.serviceVendorsDao.getAll(),
    );
    instance.tokens.addAll(
      await AppDatabase.instance.serviceTokensDao.getAll(),
    );
  }

  Future<void> _updateProvider(ServiceProvider? provider) async {
    if (provider == null) return;

    final map = await AppDatabase.instance.serviceProvidersDao.get(
      id: provider.id,
    );
    if (map != null) {
      provider.name = map['name'];
      provider.avatar = map['avatar'];
      provider.block = map['block'] == 1 ? true : false;
    }
  }

  Future<ServiceProvider?> get({String? id}) async {
    final provider = providers.firstWhereOrNull(
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
    for (final item in providers) {
      if (item.groupId == group.id && !item.block) {
        list.add(item);
      }
    }
    return list;
  }

  Iterable<ServiceToken> getTokens({required String vendorId}) {
    return tokens.where((element) => element.vendorId == vendorId);
  }

  Future<void> saveToken(ServiceToken token) async {
    final index = tokens.indexWhere((element) => element.id == token.id);
    if (index != -1) {
      tokens[index] = token;
    } else {
      tokens.add(token);
    }
    await AppDatabase.instance.serviceTokensDao.create(
      token,
    );
  }

  Future<void> block(ServiceProvider? provider, bool isBlocked) async {
    if (provider == null) return;

    provider.block = isBlocked;

    // replace block value
    await AppDatabase.instance.serviceProvidersDao.create(provider);
  }

  Future<void> changeConversation({
    required Group group,
    required Conversation conversation,
  }) async {
    final List<ServiceProvider> list = providers
        .where(
          (element) => element.groupId == group.id && !element.block,
        )
        .toList();

    for (final item in list) {
      final key = AppHiveKeys.serviceProviderIsSendHello +
          item.vendorId +
          conversation.id;
      bool? sent = AppManager.to.get(
        key: key,
      );
      final vendor = item.vendor;
      if (sent == null || !sent) {
        if (vendor.hello != null && vendor.hello!.isNotEmpty) {
          HomeController.to.onReceived(
            Message(
              id: AppUuid.value,
              type: MessageType.vendor,
              serviceAvatar: vendor.avatar,
              serviceName: vendor.name,
              serviceId: vendor.id,
              content: vendor.hello?.tr,
              fromType: MessageFromType.receive,
              createAt: DateTime.now(),
              conversationId: conversation.id,
            ),
          );
        }
        AppManager.to.set(
          key: key,
          value: true,
        );

        final tokens = getTokens(
          vendorId: item.vendorId,
        );
        final emptyValueTokens = tokens.where(
          (element) => element.value.isEmpty,
        );
        if (tokens.isNotEmpty && emptyValueTokens.isNotEmpty) {
          HomeController.to.onReceived(
            Message(
              id: AppUuid.value,
              type: MessageType.vendor,
              serviceAvatar: vendor.avatar,
              serviceName: vendor.name,
              serviceId: vendor.id,
              content: vendor.help?.tr,
              fromType: MessageFromType.receive,
              createAt: DateTime.now(),
              conversationId: conversation.id,
            ),
          );
        }
      }
    }
  }
}
