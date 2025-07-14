// lib/widgets/raffle_list.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/raffle.dart';
import 'raffle_card.dart';

class RaffleList extends StatelessWidget {
  final List<Raffle> items;
  const RaffleList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'Nuevas rifas próximamente...',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 64.0),
      itemCount: items.length,
      itemBuilder: (ctx, i) {
        final r = items[i];
        return RaffleCard(
          raffle: r,
          onTap: () async {
            await context.pushNamed(
              'raffleDetail',
              pathParameters: {'id': r.id},
              extra: r.name,
            );
          },
        );
      },
    );
  }
}
