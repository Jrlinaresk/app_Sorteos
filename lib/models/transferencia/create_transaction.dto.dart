// lib/models/create_transaction_dto.dart
class CreateTransactionDto {
  final String userId;
  final double amountUsd;
  final String paymentMethod;
  final String account;
  final double rate;
  final double fee;
  final String description;
  final String confirmationCode;
  final String typeOperation;

  CreateTransactionDto({
    required this.userId,
    required this.amountUsd,
    required this.paymentMethod,
    required this.account,
    required this.rate,
    required this.fee,
    required this.description,
    required this.confirmationCode,
    required this.typeOperation,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'amountUsd': amountUsd,
    'paymentMethod': paymentMethod,
    'account': account,
    'rate': rate,
    'fee': fee,
    'description': description,
    'confirmationCode': confirmationCode,
    'typeOperation': typeOperation,
  };
}
