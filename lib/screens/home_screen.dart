import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            Text('HomeScreen'),
            TextButton(
              onPressed: () => context.go(
                '/enroll?enroll_token=e6e1519f-4e1d-4a29-85ab-d7ee6b204d85',
              ),
              child: Text('Enroll'),
            ),
          ],
        ),
      ),
    );
  }
}
