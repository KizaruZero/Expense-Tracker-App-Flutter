import 'package:expence_tracker/models/trancs.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  String _title = ''; // Title of the transaction
  String _category = 'Makanan'; // Default category
  String _description = ''; // Description of the transaction
  double _amount = 0.0;
  bool _isIncome = false;
  DateTime _selectedDate = DateTime.now(); // Default date as current date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Form with validation
          child: ListView(
            children: [
              // Input for transaction title
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.title),
                ),
                onSaved: (value) => _title = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title'; // Validate title
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Input for transaction amount
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => _amount = double.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount'; // Validate amount
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Dropdown for selecting category
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.category),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _category = newValue!;
                  });
                },
                items: <String>[
                  'Makanan',
                  'Belanja',
                  'Transportasi',
                  'Hiburan',
                  'Tagihan',
                  'Lainnya'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Input for transaction description
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.description),
                ),
                onSaved: (value) => _description = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description'; // Validate description
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Switch for Income/Expense selection
              SwitchListTile(
                title: const Text('Income'),
                value: _isIncome,
                onChanged: (bool value) {
                  setState(() {
                    _isIncome = value;
                  });
                },
                secondary: Icon(
                  _isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                  color: _isIncome ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              // Date picker for transaction date
              ListTile(
                title: Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context), // Opens date picker
              ),
              const SizedBox(height: 16),
              // Button to add the transaction
              ElevatedButton.icon(
                onPressed: () {
                  _showConfirmationDialog(context);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Transaction'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to add this transaction?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTransaction(); // Call the function to add the transaction
              },
            ),
          ],
        );
      },
    );
  }

  void _addTransaction() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save form data
      // Create and save transaction
      final transaction = Transaction(
        title: _title,
        category: _category,
        description: _description,
        amount: _amount,
        isIncome: _isIncome,
        date: _selectedDate,
      );
      Hive.box('transactions').add(transaction);
      // Reset form after submission
      _title = '';
      _category = 'Makanan';
      _description = '';
      _amount = 0.0;
      _isIncome = false;
      _selectedDate = DateTime.now();
      setState(() {});
      // Show success notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction added successfully!')),
      );
    }
  }
}
