import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorteos_app/enums/enums.dart';
import 'package:sorteos_app/screens/error/error_status_screen.dart';
import 'package:sorteos_app/screens/favorites_screen.dart';
import 'package:sorteos_app/screens/home_screen.dart';
import 'package:sorteos_app/main_scaffold.dart';
import 'package:sorteos_app/screens/payment/confirm_transfer_screen.dart';
import 'package:sorteos_app/screens/payment/payment_screen.dart';
import 'package:sorteos_app/screens/transactions/transaction_complete_screen.dart';
import 'package:sorteos_app/screens/profile/profile_screen.dart';
import 'package:sorteos_app/screens/profile/profile_register_screen.dart';
import 'package:sorteos_app/screens/raffle_detail_screen.dart';
import 'package:sorteos_app/screens/shop_screen.dart';
import 'package:sorteos_app/screens/transactions/user_transactions_screen.dart';

final router = GoRouter(
  initialLocation: '/profile_register',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/app/home',
          name: 'home',
          pageBuilder:
              (context, state) => NoTransitionPage(child: const HomeScreen()),
          routes: [
            GoRoute(
              path: 'raffle/:id',
              name: 'raffleDetail',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: RaffleDetailScreen(
                    raffleId: state.pathParameters['id']!,
                    name: state.extra as String? ?? '',
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/app/favorites',
          name: 'favorites',
          pageBuilder:
              (context, state) =>
                  NoTransitionPage(child: const FavoritesScreen()),
        ),
        GoRoute(
          path: '/app/shop',
          name: 'shop',
          pageBuilder:
              (context, state) => NoTransitionPage(child: const ShopScreen()),
        ),
        GoRoute(
          path: '/app/profile',
          name: 'profile',
          pageBuilder: (context, state) {
            final userId = state.extra as String;
            return NoTransitionPage(child: UserProfileScreen(userId: userId));
          },
        ),
        GoRoute(
          path: '/app/transactions',
          name: 'userTransactions',
          pageBuilder:
              (context, state) =>
                  NoTransitionPage(child: const UserTransactionsScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/profile_register',
      name: 'profile_register',
      pageBuilder:
          (context, state) =>
              NoTransitionPage(child: const ProfileRegisterScreen()),
    ),
    GoRoute(
      path: '/payment',
      name: 'recharge',
      pageBuilder: (context, state) {
        // casteo seguro, puede venir null
        final extra = state.extra as Map<String, dynamic>?;
        final userId = extra?['userId'] as String?;
        if (userId == null) {
          // si no hay userId, rediriges de nuevo al home o lanzas un widget de error
          return NoTransitionPage(child: const HomeScreen());
        }
        return NoTransitionPage(child: PaymentScreen(userId: userId));
      },
    ),
    GoRoute(
      path: '/confirm',
      name: 'confirmTransfer',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final userId = extra?['userId'] as String?;
        final methodName = extra?['methodName'] as String?;
        final svg = extra?['svg'] as String?;
        final account = extra?['account'] as String?;
        final rate = extra?['rate'] as double?;
        final fee = extra?['fee'] as double?;
        final minAmount = extra?['minAmount'] as double?;
        final amountUsd = extra?['amountUsd'] as double?;
        // si falta alguno, vuelvo al home
        if ([
          userId,
          methodName,
          svg,
          account,
          rate,
          fee,
          minAmount,
          amountUsd,
        ].any((v) => v == null)) {
          return NoTransitionPage(child: const HomeScreen());
        }
        return NoTransitionPage(
          child: ConfirmTransferScreen(
            userId: userId!,
            methodName: methodName!,
            svgAsset: svg!,
            account: account!,
            rate: rate!,
            fee: fee!,
            minAmount: minAmount!,
            amountUsd: amountUsd!,
          ),
        );
      },
    ),

    /// Rutas para los estados finales de la transacción:
    GoRoute(
      path: '/transaction_complete',
      name: 'transactionComplete',
      pageBuilder: (context, state) {
        // aquí podrías recibir también un extra si necesitas algo
        return NoTransitionPage(child: const TransactionCompleteScreen());
      },
    ),
    GoRoute(
      path: '/transaction_error',
      name: 'transactionError',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final status = extra?['status'] as TxStatus?;
        final userId = extra?['userId'] as String?;
        if (status == null || userId == null) {
          // si no vienen, redirige al home
          return NoTransitionPage(child: const HomeScreen());
        }
        return NoTransitionPage(
          child: ErrorStatusScreen(status: status, userId: userId),
        );
      },
    ),
  ],

  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final hasUser = prefs.getString('userId') != null;
    final goingTo = state.matchedLocation;
    if (!hasUser && !goingTo.startsWith('/profile_register')) {
      return '/profile_register';
    }
    if (hasUser && goingTo == '/profile_register') {
      return '/app/home';
    }
    return null;
  },
);
