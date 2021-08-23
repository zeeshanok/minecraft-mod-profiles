import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final void Function(bool response) onSubmit;

  ConfirmDialog({this.title, this.content, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: title,
      content: content,
      actions: [
        TextButton(
            onPressed: () {
              onSubmit(true);
              Navigator.pop(context);
            },
            child: Text("Yes")),
        TextButton(
            onPressed: () {
              onSubmit(false);
              Navigator.of(context).pop();
            },
            child: Text("No"))
      ],
    );
  }
}
