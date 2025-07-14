class TransactionModel {
  final String id;
  final String user;
  final String paymentMethod;
  final double amountUsd;
  final double rate;
  final double fee;
  final double netAmountCup;
  final String? description;
  final String status;
  final double resultingBalance;
  final double? previousBalance;
  final String? confirmationCode;
  final DateTime createdAt;
  final String? typeOperation;

  TransactionModel({
    required this.id,
    required this.user,
    required this.paymentMethod,
    required this.amountUsd,
    required this.rate,
    required this.fee,
    required this.netAmountCup,
    this.description,
    required this.status,
    required this.resultingBalance,
    this.previousBalance,
    this.confirmationCode,
    required this.createdAt,
    this.typeOperation,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'],
      user: json['user'],
      paymentMethod: json['paymentMethod'],
      amountUsd: (json['amountUsd'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      fee: (json['fee'] as num).toDouble(),
      netAmountCup: (json['netAmountCup'] as num).toDouble(),
      description: json['description'],
      status: json['status'],
      resultingBalance: (json['resultingBalance'] as num).toDouble(),
      previousBalance: (json['previousBalance'] ?? 0 as num).toDouble(),
      confirmationCode: json['confirmationCode'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      typeOperation: json['typeOperation'],
    );
  }
}
