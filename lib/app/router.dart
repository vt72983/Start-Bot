import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/screens/token_screen.dart';
import '../ui/screens/root_decider.dart';
import '../ui/screens/control_screen.dart';
import '../ui/screens/stats_screen.dart';
import '../ui/screens/settings_screen.dart';
import '../ui/screens/home_shell.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => const RootDeciderScreen()),
    GoRoute(path: '/token', builder: (context, state) => const TokenScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => HomeShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/control', builder: (context, state) => const ControlScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/stats', builder: (context, state) => const StatsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        ]),
      ],
    ),
  ],
);


