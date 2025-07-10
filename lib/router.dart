import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorteos_app/screens/favorites_screen.dart';
import 'package:sorteos_app/screens/main_scaffold.dart';
import 'package:sorteos_app/screens/payment/confirm_transfer_screen.dart';
import 'package:sorteos_app/screens/shop_screen.dart';

import 'screens/profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/raffle_detail_screen.dart';
import 'screens/payment_screen.dart';

final router = GoRouter(
  initialLocation: '/app/home',
  routes: [
    /// ShellRoute para el scaffold que incluye Drawer + BottomBar
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        /// Home
        GoRoute(
          path: '/app/home',
          name: 'home',
          builder: (_, __) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'raffle/:id',
              name: 'raffleDetail',
              builder: (context, state) {
                return RaffleDetailScreen(
                  raffleId: state.pathParameters['id']!,
                  name: state.extra as String? ?? '',
                );
              },
            ),
          ],
        ),

        /// Favoritos
        GoRoute(
          path: '/app/favorites',
          name: 'favorites',
          builder: (_, __) => const FavoritesScreen(),
        ),

        /// Tienda
        GoRoute(
          path: '/app/shop',
          name: 'shop',
          builder: (_, __) => const ShopScreen(),
        ),

        /// Perfil
        GoRoute(
          path: '/app/profile',
          name: 'profile',
          builder: (_, __) => const ProfileScreen(),
        ),
      ],
    ),

    /// Rutas “flotantes” fuera del shell (sin BottomBar)
    GoRoute(
      path: '/payment',
      name: 'recharge',
      builder: (_, __) => const PaymentScreen(),
    ),
    GoRoute(
      path: '/confirm',
      name: 'confirmTransfer',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ConfirmTransferScreen(
          methodName: extra['methodName'],
          svgAsset: extra['svg'],
          account: extra['account'],
          rate: extra['rate'],
          fee: extra['fee'],
          minAmount: extra['minAmount'],
          amountUsd: extra['amountUsd'],
        );
      },
    ),
  ],

  /// Guard global: redirigir a perfil si no hay userId
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final hasUser = prefs.getString('userId') != null;
    final goingTo = state.matchedLocation;
    if (!hasUser && !goingTo.startsWith('/app/profile')) {
      return '/app/profile';
    }
    if (hasUser && goingTo == '/app/profile') {
      return '/app/home';
    }
    return null;
  },
);
