import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dashboard/presentation/pages/systems_board.dart';
import '../constants/app_constants.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.dashboard,
  routes: [
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      pageBuilder: (context, state) => CupertinoPage<void>(
        key: state.pageKey,
        child: const DashboardPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.systemsBoard,
      name: 'systems-board',
      pageBuilder: (context, state) => CupertinoPage<void>(
        key: state.pageKey,
        child: const SystemsBoard(),
      ),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      pageBuilder: (context, state) => CupertinoPage<void>(
        key: state.pageKey,
        child: const Scaffold(
          body: Center(
            child: Text('Settings Page - Coming Soon'),
          ),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.addServer,
      name: 'add-server',
      pageBuilder: (context, state) => CupertinoPage<void>(
        key: state.pageKey,
        child: const Scaffold(
          body: Center(
            child: Text('Add Server Page - Coming Soon'),
          ),
        ),
      ),
    ),
  ],
  errorBuilder: (context, state) => CupertinoPageScaffold(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_triangle,
            size: 64,
            color: CupertinoColors.systemRed,
          ),
          const SizedBox(height: 16),
          const Text(
            'Page not found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.error.toString(),
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CupertinoButton.filled(
            onPressed: () => context.go(AppRoutes.dashboard),
            child: const Text('Go to Dashboard'),
          ),
        ],
      ),
    ),
  ),
);
