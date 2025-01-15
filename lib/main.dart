import 'package:bgre_ton_djai/vaults_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(FinanceApp());
}

class FinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion des Finances',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePagelui(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double currentBalance = 1000.0;
  List<Map<String, dynamic>> transactions = [];

  void _addTransaction(String type) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController amountController = TextEditingController();

        return AlertDialog(
          title: Text(type == 'expense' ? 'Ajouter une dépense' : 'Ajouter un revenu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Montant'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Ajouter'),
              onPressed: () {
                final double? amount = double.tryParse(amountController.text);
                if (amount != null) {
                  setState(() {
                    transactions.add({
                      'name': nameController.text,
                      'amount': amount,
                      'type': type,
                      'date': DateTime.now(),
                    });
                    currentBalance += (type == 'expense' ? -amount : amount);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Finances'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Solde actuel : \$${currentBalance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Historique des transactions :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    title: Text(transaction['name']),
                    subtitle: Text(
                      '${transaction['type'] == 'expense' ? '-' : '+'} \$${transaction['amount'].toStringAsFixed(2)} - ${transaction['date'].toLocal()}'.split(' ')[0],
                    ),
                    leading: Icon(
                      transaction['type'] == 'expense'
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: transaction['type'] == 'expense'
                          ? Colors.red
                          : Colors.green,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _addTransaction('expense'),
            child: Icon(Icons.remove_circle_outline),
            backgroundColor: Colors.red,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => _addTransaction('income'),
            child: Icon(Icons.add_circle_outline),
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
