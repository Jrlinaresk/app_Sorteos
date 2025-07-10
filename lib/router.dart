import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorteos_app/screens/home_screen.dart';
import 'package:sorteos_app/screens/payment_screen.dart';
import 'package:sorteos_app/screens/profile_screen.dart';
import 'package:sorteos_app/screens/raffle_detail_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (_, __) => const ProfileScreen(),
    ),
    GoRoute(path: '/', name: 'home', builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/raffle/:id',
      name: 'raffleDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final name = state.extra as String;
        return RaffleDetailScreen(raffleId: id, name: name);
      },
    ),
    GoRoute(
      path: '/recharge',
      name: 'recharge',
      builder: (context, state) {
        return PaymentScreen();
      },
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) async {
    final prefs = await SharedPreferences.getInstance();
    final hasUser = prefs.getString('userId') != null;
    final loc = state.matchedLocation;

    if (!hasUser && loc != '/profile') {
      return '/profile';
    }
    if (hasUser && loc == '/profile') {
      return '/';
    }
    return null;
  },
);
