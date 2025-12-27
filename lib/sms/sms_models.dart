class SmsTransaction {
  final String id;
  final String address;
  final DateTime date;
  final String body;
  final double amount;
  final String type;
  final String? category;
  final String? merchant;

  SmsTransaction({
    required this.id,
    required this.address,
    required this.date,
    required this.body,
    required this.amount,
    required this.type,
    this.category,
    this.merchant,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'date': date.millisecondsSinceEpoch,
      'body': body,
      'amount': amount,
      'type': type,
      'category': category,
      'merchant': merchant,
    };
  }

  factory SmsTransaction.fromMap(Map<String, dynamic> map) {
    return SmsTransaction(
      id: map['id'],
      address: map['address'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      body: map['body'],
      amount: map['amount'],
      type: map['type'],
      category: map['category'],
      merchant: map['merchant'],
    );
  }
}
