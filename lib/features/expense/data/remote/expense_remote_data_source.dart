import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/expense_model.dart';

class ExpenseRemoteDataSource {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// Currency Conversion API
Future<double> convertCurrency({
  required double amount,
  required String from,
  required String to,
}) async {
  try {
    final response = await dio.get(
      'https://api.exchangerate.host/convert',
      queryParameters: {
        'from': from,
        'to': to,
        'amount': amount,
      },
    );

    final data = response.data;

    if (data == null || data['result'] == null) {
      throw Exception("Invalid conversion response");
    }

    return (data['result'] as num).toDouble();
  } catch (e) {
    debugPrint("Currency conversion failed: $e");

    // fallback: return original amount
    return amount;
  }
}


  /// Mock Sync to Server
  /// In real app → send to backend
  Future<void> syncExpense(ExpenseModel expense) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate network success
    // If you want to simulate failure randomly:
    // if (Random().nextBool()) throw Exception("Sync failed");
  }
}
