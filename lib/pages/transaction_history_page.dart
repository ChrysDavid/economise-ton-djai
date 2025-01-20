import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  // Liste des transactions (exemple de données locales)
  List<Map<String, dynamic>> transactions = [
    {'name': 'Course', 'amount': -50.0, 'category': 'Nourriture', 'date': '2025-01-18'},
    {'name': 'Salaire', 'amount': 2000.0, 'category': 'Salaire', 'date': '2025-01-15'},
    {'name': 'Restaurant', 'amount': -35.0, 'category': 'Loisirs', 'date': '2025-01-14'},
    {'name': 'Transport', 'amount': -15.0, 'category': 'Transport', 'date': '2025-01-14'},
    {'name': 'Cadeau', 'amount': -100.0, 'category': 'Autre', 'date': '2025-01-13'},
  ];

  // Filtres
  String? _selectedCategory;
  DateTime? _selectedDate;
  final TextEditingController _amountFilterController = TextEditingController();

  // Méthode pour filtrer les transactions
  List<Map<String, dynamic>> _filteredTransactions() {
    return transactions.where((transaction) {
      final matchesCategory = _selectedCategory == null ||
          transaction['category'] == _selectedCategory;
      final matchesDate = _selectedDate == null ||
          transaction['date'] == _selectedDate.toString().split(' ')[0];
      final matchesAmount = _amountFilterController.text.isEmpty ||
          transaction['amount']
              .toString()
              .contains(_amountFilterController.text);

      return matchesCategory && matchesDate && matchesAmount;
    }).toList();
  }

  // Méthode pour sélectionner une date
  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = _filteredTransactions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Transactions'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section de filtres
            const Text(
              'Filtres',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Filtre par catégorie
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: ['Nourriture', 'Salaire', 'Loisirs', 'Transport', 'Autre']
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    decoration: const InputDecoration(labelText: 'Catégorie'),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Filtre par date
                Expanded(
                  child: TextButton(
                    onPressed: () => _pickDate(context),
                    child: Text(
                      _selectedDate != null
                          ? 'Date: ${_selectedDate.toString().split(' ')[0]}'
                          : 'Choisir une date',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Filtre par montant
            TextField(
              controller: _amountFilterController,
              decoration: const InputDecoration(
                labelText: 'Montant (Rechercher)',
                hintText: 'Ex : 50',
                prefixIcon: Icon(Icons.search),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),
            // Liste des transactions filtrées
            Expanded(
              child: filteredTransactions.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        final isExpense = transaction['amount'] < 0;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(transaction['name']),
                            subtitle: Text(
                                '${transaction['category']} - ${transaction['date']}'),
                            trailing: Text(
                              '${isExpense ? '' : '+'}\$${transaction['amount'].abs().toStringAsFixed(2)}',
                              style: TextStyle(
                                color: isExpense ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('Aucune transaction trouvée.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
