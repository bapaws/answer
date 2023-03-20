import 'package:flutter/cupertino.dart';

class AppSection extends StatelessWidget {
  final Widget title;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? padding;
  const AppSection({
    Key? key,
    required this.title,
    this.actions,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.only(
            top: 16,
            left: 16,
            bottom: 8,
            right: 16,
          ),
      child: Row(
        children: [
          Expanded(child: title),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
