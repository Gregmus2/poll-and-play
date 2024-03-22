import 'package:flutter/material.dart';

class LoadingIconButton extends StatefulWidget {
  final Icon icon;
  final Function onPressed;

  const LoadingIconButton({super.key, required this.icon, required this.onPressed});

  @override
  State<LoadingIconButton> createState() => _LoadingIconButtonState();
}

class _LoadingIconButtonState extends State<LoadingIconButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isLoading ? const CircularProgressIndicator() : widget.icon,
      onPressed: () {
        setState(() {
          isLoading = true;
        });
        widget.onPressed();
      },
    );
  }
}
