import 'package:flutter/material.dart';

class EnrollScreen extends StatelessWidget {
  final String? enrollToken;
  const EnrollScreen(this.enrollToken, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Text('EnrollScreen'),
            Icon(Icons.check),
            Text('Enroll Token:'),
            Text(enrollToken ?? 'NULL'),
          ],
        ),
      ),
    );
  }
}
