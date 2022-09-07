import 'package:flutter/material.dart';

class ExceptionAlertDialog extends AlertDialog {
  final Exception exception;

  const ExceptionAlertDialog(this.exception, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: Text(exception.toString().replaceFirst("Exception: ", "")),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
