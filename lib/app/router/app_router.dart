import 'package:go_router/go_router.dart';

import '../../features/navigation/presentation/pages/main_page.dart';
import '../../features/streaks/presentation/pages/create_streak_page.dart';
import '../../features/streaks/presentation/pages/streak_detail_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/create-streak',
      builder: (context, state) => const CreateStreakPage(),
    ),
    GoRoute(
      path: '/streaks/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return StreakDetailPage(streakId: id);
      },
    ),
  ],
);