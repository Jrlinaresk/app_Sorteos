import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorteos_app/providers/providers.dart';
import 'package:sorteos_app/screens/utility/exit_confirmation_screen.dart';
import 'package:sorteos_app/screens/utility/loading_screen.dart';
import 'package:sorteos_app/theme/custom_scaffold.dart';
import 'package:sorteos_app/theme/theme.dart';
import 'package:sorteos_app/widgets/drawer/app_drawer.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

/// Este widget envuelve todas las vistas de “/app/*”
class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;
  const MainScaffold({required this.child, super.key});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  int _currentIndex = 0;
  String? _userId;
  ProviderSubscription<AsyncValue<dynamic>>? _userListener;

  /// Mapea índice de BottomBar ⇄ ruta
  static const tabs = ['/app/home', '/app/transactions', '/app/profile'];

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId');
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
  void initState() {
    super.initState();
    _loadUserId();
  }

  @override
  void dispose() {
    _userListener?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync =
        _userId == null
            ? const AsyncValue.data(null)
            : ref.watch(userProvider(_userId!));

    return WillPopScope(
      onWillPop: _onWillPop,
      child: CustomScaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: MaterialTheme.whiteColor),
          titleSpacing: 0.0,
          backgroundColor: Colors.transparent,
          title: userAsync.when(
            data: (user) {
              if (user == null) return const SizedBox();
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sorteos Cuba',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w900,
                      color: MaterialTheme.whiteColor,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${user.balance.toStringAsFixed(2)}',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(
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
                        onPressed:
                            () => context.pushNamed(
                              'recharge',
                              extra: {'userId': _userId},
                            ),
                      ),
                    ],
                  ),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const Icon(Icons.error, size: 20),
          ),
        ),
        drawer:
            _userId != null
                ? AppDrawer(scaffoldKey: _scaffoldKey, userId: _userId!)
                : null,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StylishBottomBar(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.bottomCenter,
              colors: [
                MaterialTheme.greenColor,
                MaterialTheme.greenColor,

                MaterialTheme.greenColor.withValues(alpha: 0.9),
                MaterialTheme.greenColor,

                MaterialTheme.greenColor,
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            backgroundColor: MaterialTheme.greenColor,
            iconSpace: 0.0,
            option: BubbleBarOptions(
              barStyle: BubbleBarStyle.horizontal,
              padding: EdgeInsets.only(left: 0, right: 0, top: 8),

              opacity: 0.3,
            ),
            currentIndex: _currentIndex,
            items: [
              BottomBarItem(
                unSelectedColor: Colors.white.withValues(alpha: 0.9),
                icon: const Icon(Icons.home),
                title: const Text('Home'),
                backgroundColor: Colors.white,
              ),
              BottomBarItem(
                unSelectedColor: Colors.white.withValues(alpha: 0.9),
                icon: const Icon(Icons.swap_horiz),
                title: const Text('Transacciones'),
                backgroundColor: Colors.white,
              ),
              BottomBarItem(
                unSelectedColor: Colors.white.withValues(alpha: 0.9),
                icon: const Icon(Icons.person),
                title: const Text('Perfil'),
                backgroundColor: Colors.white,
              ),
            ],
            onTap: (index) {
              setState(() => _currentIndex = index);
              context.go(tabs[index], extra: _userId);
            },
          ),
        ),

        /// Aquí va el contenido de cada ruta anidada
        child: widget.child,
      ),
    );
  }
}
