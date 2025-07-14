import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorteos_app/models/transferencia/transaction.dart';
import 'package:sorteos_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorteos_app/widgets/transsaction/transactions_list.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final userTransactionsProvider = FutureProvider<List<TransactionModel>>((
  ref,
) async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  if (userId == null) {
    throw Exception('No userId found');
  }
  final api = ref.read(apiServiceProvider);
  return api.fetchUserTransactions(userId);
});

class UserTransactionsScreen extends ConsumerWidget {
  const UserTransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(userTransactionsProvider);

    return Scaffold(
      body: txAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (txs) {
          if (txs.isEmpty) {
            return const Center(child: Text('No tienes transacciones.'));
          }
          return TransactionsList(transactions: txs);
        },
      ),
    );
  }
}
