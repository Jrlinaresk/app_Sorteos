// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/raffle.dart';
import '../providers/providers.dart';
import '../widgets/raffle_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? prefs.getString('phone');
    });
  }

  List<Raffle> _filter(
    List<Raffle> all,
    String status,
    bool excludeParticipation,
  ) {
    return all.where((r) {
      final isOpen = r.status == 'open';
      final participated = r.participants.any((p) => p.id == _userId);
      if (status == 'open') {
        return isOpen && (!excludeParticipation || !participated);
      } else if (status == 'closed') {
        return !isOpen;
      } else {
        return participated;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final rafflesAsync = ref.watch(rafflesProvider);
    return rafflesAsync.when(
      loading:
          () => const Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(child: CircularProgressIndicator()),
          ),
      error:
          (err, _) => Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(child: Text('Error: $err')),
          ),
      data: (all) {
        final open = _filter(all, 'open', true);
        final closed = _filter(all, 'closed', false);
        final mine = _filter(all, '', false);

        final tabs = <Tab>[
          if (open.isNotEmpty) const Tab(text: 'Disponibles'),
          if (closed.isNotEmpty) const Tab(text: 'Finalizadas'),
          if (mine.isNotEmpty) const Tab(text: 'Mis rifas'),
        ];

        final views = <Widget>[
          if (open.isNotEmpty) RaffleList(items: open),
          if (closed.isNotEmpty) RaffleList(items: closed),
          if (mine.isNotEmpty) RaffleList(items: mine),
        ];

        return DefaultTabController(
          key: ValueKey(tabs.length),
          length: tabs.length,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            // 1) Permite que el body se extienda detrás del AppBar
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,

              title: TabBar(
                tabs: tabs,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: TabBarView(children: views),
          ),
        );
      },
    );
  }
}
