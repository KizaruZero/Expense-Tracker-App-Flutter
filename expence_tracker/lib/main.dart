import 'package:expence_tracker/models/trancs.dart';
import 'package:expence_tracker/screens/expence_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register the TransactionAdapter
  Hive.registerAdapter(TransactionAdapter());

  // Open the Hive box
  await Hive.openBox('transactions');

  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GFG Expense Tracker',
      home: ExpenseHomeScreen(),
    );
  }
}
