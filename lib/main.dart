import 'package:BeerApp/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BeerApp());
}

class BeerApp extends StatelessWidget {
  const BeerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Beer App',
        theme: ThemeData(primarySwatch: Colors.brown),
        home: const LoginPage());
  }
}
