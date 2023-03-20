import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppCell extends StatelessWidget {
  late final Widget? leading;
  late final Widget? _trailing;
  final Widget title;
  late final Widget? description;
  late final Widget? detail;
  late final VoidCallback? onPressed;
  final Color? color;
  final bool hiddenDivider;
  final EdgeInsets? padding;
  final EdgeInsetsGeometry? margin;
  final double? minHeight;
  final double? maxHeight;

  AppCell({
    Key? key,
    this.leading,
    required this.title,
    this.description,
    this.detail,
    this.onPressed,
    this.color,
    this.hiddenDivider = false,
    this.padding,
    this.margin,
    this.minHeight,
    this.maxHeight,
    Widget? trailing,
  }) : super(key: key) {
    _trailing = trailing;
  }

  AppCell.navigation({
    Key? key,
    required this.title,
    this.leading,
    this.description,
    this.detail,
    this.onPressed,
    this.color,
    this.hiddenDivider = false,
    this.padding,
    this.margin,
    this.minHeight = 54,
    this.maxHeight = 54,
  }) : super(key: key) {
    _trailing = const Icon(Icons.chevron_right);
  }

  AppCell.switchTile({
    Key? key,
    required this.title,
    this.leading,
    this.description,
    this.detail,
    required bool initialValue,
    ValueChanged<bool>? onToggle,
    this.hiddenDivider = false,
    this.color,
    this.padding,
    this.margin,
    this.minHeight,
    this.maxHeight,
    this.onPressed,
  }) : super(key: key) {
    _trailing = CupertinoSwitch(
      value: initialValue,
      onChanged: onToggle,
    );
  }

  AppCell.checkTile({
    Key? key,
    required this.title,
    this.leading,
    this.description,
    this.detail,
    required bool initialValue,
    this.hiddenDivider = false,
    this.color,
    this.onPressed,
    this.padding,
    this.margin,
    this.minHeight,
    this.maxHeight,
  }) : super(key: key) {
    _trailing = initialValue
        ? const Icon(
            Icons.check,
            size: 18,
          )
        : null;
  }

  AppCell.textFieldTile({
    Key? key,
    required this.title,
    this.leading,
    this.hiddenDivider = false,
    TextEditingController? controller,
    FocusNode? focusNode,
    bool? enabled,
    String? hintText,
    TextInputAction? textInputAction,
    this.description,
    this.onPressed,
    this.color,
    this.padding,
    this.margin,
    this.minHeight = 44,
    this.maxHeight,
  }) : super(key: key) {
    _trailing = null;
    detail = TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      decoration: InputDecoration.collapsed(hintText: hintText),
      textInputAction: textInputAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return onPressed == null
        ? _buildTile(context)
        : GestureDetector(
            onTap: onPressed,
            child: _buildTile(context),
          );
  }

  Widget _buildTile(BuildContext context) {
    return Container(
      color: color ?? Theme.of(context).cardColor,
      padding: EdgeInsets.only(
        left: padding?.left ?? 16,
      ),
      margin: margin,
      child: Row(
        children: [
          if (leading != null)
            Padding(
              padding: const EdgeInsets.only(
                right: 16,
              ),
              child: leading!,
            ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                top: padding?.top ?? 16,
                right: padding?.right ?? 16,
                bottom: padding?.bottom ?? 16,
              ),
              // height: minHeight,
              constraints: BoxConstraints(
                minHeight: minHeight ?? 54,
                maxHeight: maxHeight ?? double.infinity,
              ),
              decoration: hiddenDivider
                  ? null
                  : BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
              child: _buildContent(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    Widget content = detail == null
        ? title
        : Row(
            children: [
              title,
              const SizedBox(
                width: 16,
              ),
              Expanded(child: detail!),
            ],
          );
    content = description == null
        ? content
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              content,
              const SizedBox(
                height: 4,
              ),
              description!,
            ],
          );
    return Row(
      children: [
        Expanded(
          child: content,
        ),
        if (_trailing != null)
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: _trailing!,
          ),
      ],
    );
  }
}
