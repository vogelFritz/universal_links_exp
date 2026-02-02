import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/send_csr.dart';

class EnrollScreen extends StatelessWidget {
  final String? enrollToken;
  const EnrollScreen(this.enrollToken, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TestProvider(),
      child: Builder(
        builder: (context) {
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
                  if (enrollToken != null)
                    Builder(
                      builder: (context) {
                        final status = context.select(
                          (TestProvider p) => p.status,
                        );
                        final error = context.select(
                          (TestProvider p) => p.error,
                        );
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            TextButton(
                              onPressed: status == TestStatus.inProgress
                                  ? null
                                  : () => context.read<TestProvider>().test(
                                      enrollToken!,
                                    ),
                              child: Text('Test'),
                            ),
                            if (status == TestStatus.inProgress)
                              CircularProgressIndicator(),
                            if (error != null) Text(error),
                            if (status == TestStatus.success) Icon(Icons.check),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

enum TestStatus { initial, inProgress, failure, success }

class TestProvider extends ChangeNotifier {
  TestStatus _status = TestStatus.initial;
  String? _error;

  TestStatus get status => _status;
  String? get error => _error;

  Future<void> test(String enrollToken) async {
    _status = TestStatus.inProgress;
    notifyListeners();
    try {
      await testEndpoints(enrollToken);
      _status = TestStatus.success;
    } catch (e) {
      _error = e.toString();
      _status = TestStatus.failure;
    }
    notifyListeners();
  }
}
