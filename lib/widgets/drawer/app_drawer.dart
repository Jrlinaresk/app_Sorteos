import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorteos_app/constants/constants.dart';
import 'package:sorteos_app/models/user.dart';
import 'package:sorteos_app/providers/providers.dart';
import 'package:sorteos_app/screens/profile/profile_screen.dart';
import 'package:sorteos_app/services/api_service.dart';
import 'package:sorteos_app/theme/theme.dart';

// Proveedor de ApiService
final apiServiceProvider = Provider((ref) => ApiService());

/// Drawer widget showing user info and navigation items without GetX.
class AppDrawer extends ConsumerWidget {
  final String userId;
  final dynamic scaffoldKey;

  const AppDrawer({Key? key, required this.userId, required this.scaffoldKey})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider(userId));

    return Drawer(
      width: 240.w,
      backgroundColor: MaterialTheme.greenColor,
      child: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (e, _) => Center(
              child: Text('Error: \$e', style: TextStyle(color: Colors.white)),
            ),
        data:
            (user) => SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  CircleAvatar(
                    radius: 44.r,
                    backgroundImage: NetworkImage(user.profilePictureUrl),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    user.nickname,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: MaterialTheme.whiteColor,
                    ),
                  ),
                  Text(
                    user.phone,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: MaterialTheme.whiteColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Divider(
                    color: MaterialTheme.whiteColor.withValues(alpha: .2),
                    thickness: 1,
                  ),

                  // Navigation items
                  _DrawerItem(
                    icon: TablerIcons.home,
                    label: 'Inicio',
                    routeName: 'home',
                    scaffoldKey: scaffoldKey,
                  ),
                  Divider(
                    color: MaterialTheme.whiteColor.withValues(alpha: .1),
                    height: .3,
                    thickness: kBorderWidth,
                  ),
                  // _DrawerItem(
                  //   icon: TablerIcons.location,
                  //   label: 'Ubicacion',
                  //   routeName: 'locations',
                  //   scaffoldKey: scaffoldKey,
                  // ),
                  // Divider(
                  //   color: MaterialTheme.otherColor2.withValues(alpha: .2),
                  //   height: .3,
                  //   thickness: kBorderWidth,
                  // ),
                  // _DrawerItem(
                  //   icon: TablerIcons.message_dots,
                  //   label: 'Chat',
                  //   routeName: 'messages',
                  //   scaffoldKey: scaffoldKey,
                  // ),
                  // Divider(
                  //   color: MaterialTheme.otherColor2.withValues(alpha: .2),
                  //   height: .3,
                  //   thickness: kBorderWidth,
                  // ),
                  // _DrawerItem(
                  //   icon: TablerIcons.calendar_check,
                  //   label: 'Calendario',
                  //   routeName: 'canguros',
                  //   scaffoldKey: scaffoldKey,
                  // ),
                  // Divider(
                  //   color: MaterialTheme.otherColor2.withValues(alpha: .2),
                  //   height: .3,
                  //   thickness: kBorderWidth,
                  // ),
                  _DrawerItem(
                    icon: TablerIcons.credit_card,
                    label: 'Trassaciones',
                    routeName: 'userTransactions',
                    scaffoldKey: scaffoldKey,
                  ),
                  Divider(
                    color: MaterialTheme.whiteColor.withValues(alpha: .1),
                    height: .3,
                    thickness: kBorderWidth,
                  ),
                  _DrawerItem(
                    userId: userId,
                    icon: Icons.add_circle_outline,
                    label: 'Recargas',
                    routeName: 'recharge',
                    scaffoldKey: scaffoldKey,
                  ),
                  // _DrawerItem(
                  //   icon: TablerIcons.settings,
                  //   label: 'Ajustes',
                  //   routeName: 'settings',
                  //   scaffoldKey: scaffoldKey,
                  // ),
                  Divider(color: MaterialTheme.whiteColor, thickness: .2),
                  SizedBox(height: 8.h),
                  Spacer(),

                  Image.asset("assets/images/logo_white.png", width: 118.w),
                  // Logout
                  // ── Logout ──────────────────────────
                  GestureDetector(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      context.go('/app/profile_register');
                      scaffoldKey.currentState?.closeDrawer();
                    },
                    child: Text(
                      'Cerrar sesión',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: MaterialTheme.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    this.userId,
    required this.icon,
    required this.label,
    required this.routeName,
    required this.scaffoldKey,
  });

  final String? userId;
  final IconData icon;
  final String label;
  final String routeName;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: MaterialTheme.whiteColor),
      title: Text(label, style: TextStyle(color: MaterialTheme.whiteColor)),
      onTap: () {
        scaffoldKey.currentState?.closeDrawer();

        userId != null
            ? context.pushNamed(routeName, extra: {'userId': userId})
            : context.pushNamed(routeName);
      },
      style: ListTileStyle.drawer,
    );
  }
}
