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

  Future<double> convertCurrency({
    required double amount,
    required String from,
    required String to,
  }) async {
    try {
      final response = await dio.get(
        'https://api.frankfurter.app/latest',
        queryParameters: {
          'amount': amount,
          'from': from,
          'to': to,
        },
      );

      final data = response.data;

      if (data == null ||
          data['rates'] == null ||
          data['rates'][to] == null) {
        throw Exception("Invalid conversion response");
      }

      return (data['rates'][to] as num).toDouble();
    } catch (e) {
      debugPrint("Currency conversion failed: $e");
      return amount;
    }
  }

  Future<void> syncExpense(ExpenseModel expense) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
