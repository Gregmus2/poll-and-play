import 'package:flutter/material.dart';

abstract class Page extends Widget {
  const Page({super.key});

  Widget getIcon(BuildContext context) => const Icon(Icons.not_interested, color: Colors.white);

  Widget getUnselectedIcon(BuildContext context) => const Icon(Icons.not_interested, color: Colors.white);

  Widget? floatingActionButton(BuildContext context) => null;

  String getLabel() => "";

  void onSelected(BuildContext context) {}
}
