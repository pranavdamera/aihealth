import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'screens/auth.dart';
import 'screens/home.dart';
import 'screens/settings.dart';
import 'screens/export.dart';
import 'screens/help.dart';
import 'screens/sign_up.dart'; // ✅ Add this

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/auth',
    ),
    GoRoute(
      path: '/auth',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const AuthScreen(),
      ),
    ),
    GoRoute(
      path: '/signup', // ✅ Add signup route
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const SignupScreen(),
      ),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const SettingsScreen(),
      ),
    ),
    GoRoute(
      path: '/export',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ExportScreen(),
      ),
    ),
    GoRoute(
      path: '/help',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const HelpScreen(),
      ),
    ),
  ],
);
