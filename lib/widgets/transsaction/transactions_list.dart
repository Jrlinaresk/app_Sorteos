import 'package:flutter/material.dart';
import 'package:sorteos_app/models/transferencia/transaction.dart';
import 'package:sorteos_app/widgets/transsaction/transaction_item.dart';

class TransactionsList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: transactions.length,
      separatorBuilder: (_, __) => SizedBox.shrink(),
      itemBuilder: (context, index) {
        return TransactionItem(tx: transactions[index]);
      },
    );
  }
}
