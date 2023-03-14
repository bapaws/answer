import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin RefreshMixin on GetLifeCycleBase {
  ScrollController get scroll;

  @override
  void onInit() {
    super.onInit();
    scroll.addListener(_listener);
  }

  bool canFetchBottom = true;

  bool canFetchTop = true;

  void _listener() {
    final position = scroll.position;
    if (position.pixels < position.minScrollExtent + 16 ||
        position.pixels > position.maxScrollExtent - 16) {
      _checkIfCanLoadMore();
    }
  }

  Future<void> _checkIfCanLoadMore() async {
    if (scroll.position.pixels == 0) {
      if (!canFetchTop) return;
      canFetchTop = false;
      await onTopScroll();
      canFetchTop = true;
    } else {
      if (!canFetchBottom) return;
      canFetchBottom = false;
      await onEndScroll();
      canFetchBottom = true;
    }
  }

  Future<void> onEndScroll();

  Future<void> onTopScroll();

  @override
  void onClose() {
    scroll.removeListener(_listener);
    super.onClose();
  }
}
