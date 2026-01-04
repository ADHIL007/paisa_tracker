class SummaryModel {
  final double totalExpense;
  final double totalIncome;
  final double todayExpense;
  final double totalSent;
  final double totalReceived;

  SummaryModel({
    this.totalExpense = 0.0,
    this.totalIncome = 0.0,
    this.todayExpense = 0.0,
    this.totalSent = 0.0,
    this.totalReceived = 0.0,
  });

  @override
  String toString() {
    return 'SummaryModel(totalExpense: $totalExpense, totalIncome: $totalIncome, '
        'todayExpense: $todayExpense, totalSent: $totalSent, totalReceived: $totalReceived)';
  }
}
