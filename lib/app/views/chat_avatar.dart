import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatAvatar extends StatelessWidget {
  final String? path;
  final double width;
  final double height;
  final Radius? radius;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? color;
  const ChatAvatar({
    Key? key,
    required this.path,
    this.width = 44,
    this.height = 44,
    this.radius = const Radius.circular(8),
    this.fit = BoxFit.cover,
    this.padding,
    this.backgroundColor,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? widget;
    if (path != null && path!.startsWith('assets/images/')) {
      if (path!.endsWith('.svg')) {
        widget = SvgPicture.asset(
          path!,
          width: width - (padding?.horizontal ?? 0),
          height: height - (padding?.vertical ?? 0),
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          placeholderBuilder: (context) => _buildPlaceholder(context),
        );
      } else {
        widget = Image.asset(path!);
      }
    } else if (path != null && path!.startsWith('http')) {
      widget = CachedNetworkImage(
        imageUrl: path!,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) => _buildPlaceholder(context),
        errorWidget: (context, url, error) => _buildPlaceholder(context),
      );
    }
    widget ??= _buildPlaceholder(context);

    return Container(
      width: width,
      height: height,
      padding: padding,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: radius == null ? null : BorderRadius.all(radius!),
        color: backgroundColor,
      ),
      child: widget,
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: min(width, height) - 16,
          color: Colors.white70,
        ),
      ),
    );
  }
}
