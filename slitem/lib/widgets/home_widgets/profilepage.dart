import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String email;
  final String userId;

  const ProfilePage({Key? key, required this.email, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userId),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'User name: $userId',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
