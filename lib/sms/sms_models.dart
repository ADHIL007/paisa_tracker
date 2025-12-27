class Transaction {
  final String id;
  final String address;
  final DateTime date;
  final String body;
  final double amount;
  final String type; 
  final String? category;
  final String? merchant;

  Transaction({
    required this.id,
    required this.address,
    required this.date,
    required this.body,
    required this.amount,
    required this.type,
    this.category,
    this.merchant,
  });
}
