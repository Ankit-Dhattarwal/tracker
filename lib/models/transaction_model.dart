class Transaction {
  final String type;
  final String description;
  final double amount;
  final DateTime date;

  // constructor
  Transaction({
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['type'],
      description: json['description'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }
}
