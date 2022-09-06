import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search results"),
      ),
      body: Center(child: Text(message, textAlign: TextAlign.center)),
    );
  }
}
