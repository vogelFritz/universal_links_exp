import 'package:go_router/go_router.dart';

import '../../screens/enroll_screen.dart';
import '../../screens/home_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) => HomeScreen(),
      routes: [
        GoRoute(
          path: '/enroll',
          builder: (_, state) {
            final enrollToken = state.uri.queryParameters['enroll_token'];
            return EnrollScreen(enrollToken);
          },
        ),
      ],
    ),
  ],
);
