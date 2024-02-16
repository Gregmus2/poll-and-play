import 'package:flutter/material.dart';

abstract class Page extends Widget {
  const Page({super.key});

  Icon getIcon(BuildContext context) => const Icon(Icons.not_interested, color: Colors.white);
  Icon getUnselectedIcon(BuildContext context) => const Icon(Icons.not_interested, color: Colors.white);

  String getLabel() => "";
}
