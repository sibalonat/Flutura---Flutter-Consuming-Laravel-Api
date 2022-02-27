class Transaction {
  int id;
  int categoryId;
  String categoryName;
  String amount;
  String description;
  String transactionDate;
  String createdAt;


  Transaction({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.description,
    required this.transactionDate,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      amount: json['amount'],
      description: json['description'],
      transactionDate: json['transaction_date'],
      createdAt: json['created_at'],
    );
  }
}