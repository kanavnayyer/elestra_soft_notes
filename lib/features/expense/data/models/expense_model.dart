class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final String currency;
  final String category;
  final DateTime date;
  final bool isSynced;
  final DateTime updatedAt;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.category,
    required this.date,
    required this.updatedAt,
    this.isSynced = false,
  });

  ExpenseModel copyWith({
    String? id,
    String? title,
    double? amount,
    String? currency,
    String? category,
    DateTime? date,
    bool? isSynced,
    DateTime? updatedAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      date: date ?? this.date,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'currency': currency,
      'category': category,
      'date': date.toIso8601String(),
      'isSynced': isSynced ? 1 : 0,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }


  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      currency: map['currency'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      isSynced: map['isSynced'] == 1,
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }


  Map<String, dynamic> toJson() => toMap();

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      ExpenseModel.fromMap(json);
}
