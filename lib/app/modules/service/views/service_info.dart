import 'package:flutter/material.dart';

import '../../../providers/service_provider.dart';
import '../../../views/chat_avatar.dart';

class ServiceInfo extends StatelessWidget {
  const ServiceInfo({
    super.key,
    required this.provider,
  });

  final ServiceProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatAvatar(
            path: provider.avatar,
            radius: const Radius.circular(8),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'ID: ${provider.id}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
