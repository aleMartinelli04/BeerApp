import 'package:BeerApp/db/db.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final User user = Database().currentUser;

  ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    _controllerEmail.text = widget.user.email;
    _controllerPassword.text = widget.user.password;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                          "https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg",
                          width: 100,
                          height: 100),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Icon(Icons.mail),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _controllerEmail,
                      enabled: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.password),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _controllerPassword,
                      obscureText: _obscureText,
                      enabled: false,
                    ),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                      icon: Icon(_obscureText
                          ? Icons.visibility
                          : Icons.visibility_off)),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  child: const Text('Logout'),
                  onPressed: () {
                    Database().logout().then((value) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
