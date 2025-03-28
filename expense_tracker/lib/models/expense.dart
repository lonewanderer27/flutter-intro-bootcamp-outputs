import 'package:expense_tracker/enums/category.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final dateFormatter = DateFormat.yMd();

final Uuid uuid = Uuid();

class Expense {
  Expense(
      {required this.amount,
      required this.title,
      required this.date,
      required this.category,
      String? id})
      : id = id ?? uuid.v4();

  String get formattedDate {
    return dateFormatter.format(date);
  }

  factory Expense.fromJSON(Map<String, dynamic> json) {
    return Expense(
        amount: json['amount'],
        title: json['title'],
        date: json['date'],
        category: json['category'],
        id: json['id']);
  }

  Map<String, dynamic> toJSON() {
    return {
      'amount': amount,
      'title': title,
      'date': date,
      'category': category,
      'id': id
    };
  }

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
}
