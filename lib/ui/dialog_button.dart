import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({
    required this.text,
    required this.onPressed,
    required this.color,
    super.key,
  });

  final Color color;
  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: const ButtonStyle(
            shape: MaterialStatePropertyAll(BeveledRectangleBorder()),
            alignment: AlignmentDirectional.center,
            padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 10, horizontal: 10))),
        child: Text(text, style: TextStyle(color: color, fontSize: 15)));
  }
}

List<Widget> simpleDialogButtons(BuildContext context, {required VoidCallback ok, required VoidCallback cancel}) {
  return [
    DialogButton(text: 'OK', onPressed: ok, color: Theme.of(context).colorScheme.primary),
    DialogButton(text: 'CANCEL', onPressed: cancel, color: Theme.of(context).colorScheme.error)
  ];
}
