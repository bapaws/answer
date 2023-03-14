import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'app_controller_mixin.dart';

mixin AppViewMixin<Controller extends AppControllerMixin> {
  BuildContext get context => Get.context!;

  String? get tag => null;
  Controller get controller => GetInstance().find<Controller>(tag: tag);

  String? get title => null;
  Color? get backgroundColor => null;
  Color? get statusBarColor => Colors.transparent;
  Color? get systemNavigationBarColor =>
      Theme.of(context).scaffoldBackgroundColor;

  bool get topSafeArea => false;
  bool get bottomSafeArea => false;

  Widget buildBody(BuildContext context);

  Widget build(BuildContext context) {
    return buildAnnotatedRegion(context);
  }

  Widget buildAnnotatedRegion(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        systemNavigationBarColor: systemNavigationBarColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: buildScaffold(context),
      ),
    );
  }

  Widget buildScaffold(BuildContext context) {
    return GetBuilder<Controller>(
      builder: (controller) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: buildAppBar(context),
        body: buildPage(context),
        floatingActionButton: buildFloatingActionButton(context),
        bottomNavigationBar: buildBottomNavigationBar(context),
        drawer: buildDrawer(),
      ),
    );
  }

  PreferredSizeWidget? buildAppBar(BuildContext context) {
    if (title == null) return null;

    return AppBar(title: Text(title!));
  }

  Widget buildPage(BuildContext context) {
    return SafeArea(
      top: topSafeArea,
      bottom: bottomSafeArea,
      child: buildBody(context),
    );
  }

  Widget? buildFloatingActionButton(BuildContext context) => null;
  Widget? buildBottomNavigationBar(BuildContext context) => null;

  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
    );
  }

  Widget? buildDrawer() {
    return null;
  }
}
