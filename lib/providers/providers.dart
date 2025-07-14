import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorteos_app/models/category.dart';
import 'package:sorteos_app/models/raffle.dart';
import 'package:sorteos_app/models/transferencia/create_transaction.dto.dart';
import 'package:sorteos_app/models/transferencia/transaction.dart';
import 'package:sorteos_app/models/user.dart';
import 'package:sorteos_app/services/api_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return ref.read(apiServiceProvider).fetchCategories();
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final rafflesProvider = FutureProvider<List<Raffle>>((ref) async {
  final categoryId = ref.watch(selectedCategoryProvider);
  return ref.read(apiServiceProvider).fetchRaffles(categoryId: categoryId);
});

final raffleDetailProvider = FutureProvider.family<Raffle, String>((
  ref,
  id,
) async {
  return ref.read(apiServiceProvider).fetchRaffle(id);
});

final userProvider = FutureProvider.family<User, String>((ref, id) async {
  return ref.read(apiServiceProvider).fetchUser(id);
});
final createTransactionProvider =
    FutureProvider.family<TransactionModel, CreateTransactionDto>((
      ref,
      dto,
    ) async {
      return ref.read(apiServiceProvider).createTransaction(dto);
    });
