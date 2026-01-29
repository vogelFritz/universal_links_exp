import 'package:flutter/material.dart';

class EnrollScreen extends StatelessWidget {
  const EnrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 16,
          children: [Text('EnrollScreen'), Icon(Icons.check)],
        ),
      ),
    );
  }
}
