import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorteos_app/theme/theme.dart';
import 'package:sorteos_app/widgets/custom_tabBar.dart';
import '../widgets/raffles_tabs.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? _userId;
  List<bool> _tabsVisibility = [true, true, true];

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId') ?? prefs.getString('phone');
    setState(() {
      _userId = id;
      _tabController = TabController(length: 3, vsync: this);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomTabBar(
          controller: _tabController!,
          tabs: [
            if (_tabsVisibility[0]) const Tab(text: 'Disponibles'),
            if (_tabsVisibility[1]) const Tab(text: 'Finalizadas'),
            if (_tabsVisibility[2]) const Tab(text: 'Mis rifas'),
          ],
        ),
      ),
      body: Container(
        color: Colors.transparent,
        child:
            _userId == null
                ? const Center(child: Text('Usuario no identificado'))
                : RafflesTabs(
                  userId: _userId!,
                  tabController: _tabController!,
                  onTabsVisibility: (visible) {
                    setState(() => _tabsVisibility = visible);
                  },
                ),
      ),
    );
  }
}
