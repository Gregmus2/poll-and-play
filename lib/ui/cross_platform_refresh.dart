import 'dart:ui';

import 'package:flutter/material.dart';

class CrossPlatformRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const CrossPlatformRefreshIndicator({
    required this.onRefresh,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        physics: const BouncingScrollPhysics(),
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad},
      ),
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: child,
      ),
    );
  }
}
