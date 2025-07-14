// lib/widgets/raffles_tabs.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sorteos_app/screens/loading_screen.dart';
import 'package:sorteos_app/widgets/raffle_card.dart';

import '../models/raffle.dart';
import '../providers/providers.dart';

class RafflesTabs extends ConsumerStatefulWidget {
  const RafflesTabs({
    super.key,
    required this.userId,
    required this.tabController,
    required this.onTabsVisibility,
  });

  final String userId;
  final TabController tabController;
  final void Function(List<bool>) onTabsVisibility;

  @override
  ConsumerState<RafflesTabs> createState() => _RafflesTabsState();
}

class _RafflesTabsState extends ConsumerState<RafflesTabs> {
  late final ProviderSubscription<AsyncValue<List<Raffle>>> _sub;

  @override
  void initState() {
    super.initState();
    _sub = ref.listenManual<AsyncValue<List<Raffle>>>(rafflesProvider, (
      prev,
      next,
    ) {
      if (next.isLoading) {
        LoadingScreen.show(
          context,
          message: 'Cargando tus rifas',
          logo: Image.asset('assets/images/logo_white.png'),
        );
      } else {
        LoadingScreen.hide(context);
      }
    });
  }

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rafflesAsync = ref.watch(rafflesProvider);

    List<Raffle> _filter(String status, bool excludeParticipation) {
      final all = rafflesAsync.asData?.value ?? [];
      return all.where((r) {
        final isOpen = r.status == 'open';
        final participated = r.participants.any((p) => p.id == widget.userId);
        if (status == 'open') {
          return isOpen && (!excludeParticipation || !participated);
        } else if (status == 'closed') {
          return !isOpen;
        } else {
          return participated;
        }
      }).toList();
    }

    final open = _filter('open', true);
    final closed = _filter('closed', false);
    final mine = _filter('', false);

    // Después de construir, avisamos de la nueva visibilidad
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTabsVisibility([
        open.isNotEmpty,
        closed.isNotEmpty,
        mine.isNotEmpty,
      ]);
    });

    final tabsContent = <Widget>[];
    if (open.isNotEmpty) tabsContent.add(_buildList(open));
    if (closed.isNotEmpty) tabsContent.add(_buildList(closed));
    if (mine.isNotEmpty) tabsContent.add(_buildList(mine));

    return rafflesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Center(child: Text('Error: $e')),
      data:
          (_) => Theme(
            data: Theme.of(context).copyWith(
              tabBarTheme: const TabBarTheme(
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
              ),
            ),
            child: TabBarView(
              controller: widget.tabController,
              children: tabsContent,
            ),
          ),
    );
  }

  Widget _buildList(List<Raffle> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text(
          'Nuevas rifas próximamente...',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (ctx, i) {
          final r = list[i];
          return RaffleCard(
            raffle: r,
            onTap: () async {
              await context.pushNamed(
                'raffleDetail',
                pathParameters: {'id': r.id},
                extra: r.name,
              );
              ref.refresh(userProvider(widget.userId));
            },
          );
        },
      ),
    );
  }
}
