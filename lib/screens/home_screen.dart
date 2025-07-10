import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorteos_app/screens/exit_confirmation_screen.dart';
import 'package:sorteos_app/screens/loading_screen.dart';
import 'package:sorteos_app/theme/background_layer.dart';
import 'package:sorteos_app/theme/theme.dart';
import 'package:sorteos_app/widgets/custom_tabBar.dart';

import '../widgets/raffles_tabs.dart';
import '../providers/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  String? _userId;
  late final TabController _tabController;
  ProviderSubscription<AsyncValue<dynamic>>? _userListener;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserId();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userListener?.close();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId') ?? prefs.getString('phone');
    setState(() => _userId = id);

    if (_userId != null) {
      // ✅ Usar listenManual porque estamos fuera de build
      _userListener = ref.listenManual<AsyncValue<dynamic>>(
        userProvider(_userId!),
        (previous, next) {
          if (next.isLoading) {
            LoadingScreen.show(
              context,
              message: 'Cargando tu perfil…',
              logo: Image.asset('assets/images/logo_white.png'),
            );
          } else {
            LoadingScreen.hide(context);
          }
        },
        fireImmediately: true,
      );
    }
  }

  /// Este método se dispara cuando el usuario pulsa “atrás”
  Future<bool> _onWillPop() async {
    // Abrimos la confirmación; si devuelve true, se cierra la app
    return await ExitConfirmationScreen.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final userAsync =
        _userId == null
            ? const AsyncValue.data(null)
            : ref.watch(userProvider(_userId!));

    return WillPopScope(
      onWillPop: _onWillPop,
      child: BackgroundLayer(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: userAsync.when(
            data: (user) {
              if (user == null) return const SizedBox();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${user.balance.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.w900,
                      color: MaterialTheme.whiteColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: MaterialTheme.whiteColor,
                      size: 28.w,
                    ),
                    tooltip: 'Recargar saldo',
                    onPressed: () => context.pushNamed('recharge'),
                  ),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const Icon(Icons.error, size: 20),
          ),
          bottom: CustomTabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Disponibles'),
              Tab(text: 'Finalizadas'),
              Tab(text: 'Mis rifas'),
            ],
          ),
        ),
        child:
            _userId == null
                ? const Center(child: Text('Usuario no identificado'))
                : RafflesTabs(userId: _userId!, tabController: _tabController),
      ),
    );
  }
}
