import 'package:flutter/material.dart';


class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Utile';
  final List<String> _categories = ['Utile', 'Inutile'];

  void _submitTransaction() {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) {
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter une Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom de la transaction'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Montant'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField(
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value.toString();
                });
              },
              decoration: InputDecoration(labelText: 'Catégorie'),
            ),
            ElevatedButton(
              onPressed: _submitTransaction,
              child: Text('Ajouter la Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
