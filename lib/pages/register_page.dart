import 'package:flutter/material.dart';

import '../utilities/users_manager.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
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
                  try {
                    String mail = _emailController.text;
                    String password = _passwordController.text;

                    if (mail.isEmpty || password.isEmpty) {
                      throw Exception("Empty fields");
                    }

                    UsersManager().addUser(mail, password);

                    showDialog(
                      context: context,
                      builder: (context2) {
                        return AlertDialog(
                          title: const Text("Success"),
                          content: const Text("User registered"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context2);
                              },
                              child: const Text("Ok"),
                            )
                          ],
                        );
                      },
                    );

                    _emailController.clear();
                    _passwordController.clear();
                  } catch (e) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Error"),
                            content: Text(e.toString()),
                          );
                        });
                  }
                },
                child: const Text("Register"),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
