import 'package:BeerApp/db/db.dart';
import 'package:BeerApp/pages/page_manager.dart';
import 'package:BeerApp/pages/register_page.dart';
import 'package:BeerApp/utilities/exception_alert.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Email"),
                ),
                controller: _emailController,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Password"),
                ),
                controller: _passwordController,
              ),
              const Padding(padding: EdgeInsets.all(30)),
              ElevatedButton(
                onPressed: () {
                  String mail = _emailController.text;
                  String password = _passwordController.text;

                  if (mail.isEmpty || password.isEmpty) {
                    showDialog(
                        context: context,
                        builder: ExceptionAlertDialog(Exception("Empty fields"))
                            .build);
                    return;
                  }

                  Database().checkUser(mail, password).then((value) {
                    Database().login(mail).then((value) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return const PageManager();
                        }),
                      );
                    });
                  }).catchError((e) {
                    showDialog(
                        context: context,
                        builder: ExceptionAlertDialog(e).build);
                  });

                  _emailController.clear();
                  _passwordController.clear();
                },
                child: const Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return const RegisterPage();
                    }),
                  );
                },
                child: const Text("Or Register Here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
