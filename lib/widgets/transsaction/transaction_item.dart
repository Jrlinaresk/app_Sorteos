import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sorteos_app/models/transferencia/transaction.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel tx;

  const TransactionItem({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final isIngreso = tx.netAmountCup >= 0;
    final df = DateFormat.yMMMd().add_Hm(); // Jul 11, 2025 14:23
    final statusLabel =
        '${tx.status[0].toUpperCase()}${tx.status.substring(1)}';
    final amountText =
        '${isIngreso ? '+' : '-'}\$${tx.netAmountCup.abs().toStringAsFixed(2)} CUP';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ── Icono circular
            Container(
              decoration: BoxDecoration(
                color:
                    isIngreso
                        ? Colors.green.withOpacity(.1)
                        : Colors.red.withOpacity(.1),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                isIngreso
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: isIngreso ? Colors.green : Colors.red,
                size: 24,
              ),
            ),

            const SizedBox(width: 12),

            // ── Texto principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Monto
                  Text(
                    amountText.split("\$")[1],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isIngreso ? Colors.green : Colors.red,
                    ),
                  ),
                  // Descripción
                  Text(
                    tx.description ?? 'Sin descripción',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Fecha y código, en una línea
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        df.format(tx.createdAt.toLocal()),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      tx.confirmationCode != ''
                          ? Icon(
                            Icons.vpn_key,
                            size: 14,
                            color: Colors.grey[600],
                          )
                          : const SizedBox.shrink(),
                      const SizedBox(width: 4),
                      tx.confirmationCode != ''
                          ? Text(
                            tx.confirmationCode!,
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                          : const SizedBox.shrink(),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Chips de método y estado
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Chip(
                        label: Text(tx.paymentMethod),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ),
                      ),
                      Chip(
                        label: Text(statusLabel),
                        backgroundColor:
                            tx.status == 'completed'
                                ? Colors.green.withOpacity(.2)
                                : tx.status == 'pending'
                                ? Colors.orange.withOpacity(.2)
                                : Colors.red.withOpacity(.2),
                        labelStyle: TextStyle(
                          color:
                              tx.status == 'completed'
                                  ? Colors.green[800]
                                  : tx.status == 'pending'
                                  ? Colors.orange[800]
                                  : Colors.red[800],
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
