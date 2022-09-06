import 'package:BeerApp/pages/page_manager.dart';
import 'package:BeerApp/pages/register_page.dart';
import 'package:BeerApp/utilities/users_manager.dart';
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
                  try {
                    String mail = _emailController.text;
                    String password = _passwordController.text;

                    if (mail.isEmpty || password.isEmpty) {
                      throw Exception("Empty fields");
                    }

                    UsersManager().checkUser(mail, password);
                    UsersManager().login(mail, password);

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return const PageManager();
                      }),
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
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        });
                  }
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
