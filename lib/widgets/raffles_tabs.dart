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
  });

  final String userId;
  final TabController tabController;

  @override
  ConsumerState<RafflesTabs> createState() => _RafflesTabsState();
}

class _RafflesTabsState extends ConsumerState<RafflesTabs> {
  late final ProviderSubscription<AsyncValue<List<Raffle>>> _sub;
  @override
  void initState() {
    super.initState();
    // Escuchamos manualmente el estado de rafflesProvider
    _sub = ref.listenManual<AsyncValue<List<Raffle>>>(rafflesProvider, (
      prev,
      next,
    ) {
      if (next.isLoading) {
        LoadingScreen.show(
          context,
          message: 'Cargando tu rifas',
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
        } else /* mis rifas */ {
          return participated;
        }
      }).toList();
    }

    Widget _buildList(List<Raffle> list) {
      if (list.isEmpty) {
        return Center(child: Text('Nuevas rifas proximamente...'));
      }
      return ListView.builder(
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
      );
    }

    return rafflesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Center(child: Text('Error: $e')),
      data:
          (_) => Card(
            margin: const EdgeInsets.only(top: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            color: Colors.white,
            child: TabBarView(
              controller: widget.tabController,
              children: [
                _buildList(_filter('open', true)), // disponibles
                _buildList(_filter('closed', false)), // finalizadas
                _buildList(_filter('', false)), // mis rifas
              ],
            ),
          ),
    );
  }
}
