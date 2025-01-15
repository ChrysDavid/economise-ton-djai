import 'package:bgre_ton_djai/add_transaction_page.dart';
import 'package:flutter/material.dart';


class HomePagelui extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Finances'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTransactionPage()),
                );
              },
              child: Text('Ajouter une Transaction'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VaultsPage()),
                );
              },
              child: Text('Voir les Coffres'),
            ),
          ],
        ),
      ),
    );
  }
}

class VaultsPage extends StatefulWidget {
  @override
  _VaultsPageState createState() => _VaultsPageState();
}

class _VaultsPageState extends State<VaultsPage> {
  List<Map<String, dynamic>> vaults = [];
  final TextEditingController _vaultNameController = TextEditingController();
  final TextEditingController _vaultGoalController = TextEditingController();
  double mainBalance = 1000.0;

  void _addVault() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Créer un Nouveau Coffre'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _vaultNameController,
                decoration: InputDecoration(labelText: 'Nom du Coffre'),
              ),
              TextField(
                controller: _vaultGoalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Objectif (optionnel)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Créer'),
              onPressed: () {
                setState(() {
                  vaults.add({
                    'name': _vaultNameController.text,
                    'goal': double.tryParse(_vaultGoalController.text) ?? 0,
                    'balance': 0.0,
                  });
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _transferToVault(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController transferAmountController = TextEditingController();
        return AlertDialog(
          title: Text('Transférer vers le Coffre'),
          content: TextField(
            controller: transferAmountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Montant'),
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Transférer'),
              onPressed: () {
                final double? amount = double.tryParse(transferAmountController.text);
                if (amount != null && amount <= mainBalance) {
                  setState(() {
                    mainBalance -= amount;
                    vaults[index]['balance'] += amount;
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
      appBar: AppBar(title: Text('Coffres')),
      body: Column(
        children: [
          Text('Solde Principal: \$${mainBalance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: vaults.length,
              itemBuilder: (context, index) {
                final vault = vaults[index];
                return ListTile(
                  title: Text(vault['name']),
                  subtitle: Text('Solde: \$${vault['balance'].toStringAsFixed(2)}'),
                  trailing: ElevatedButton(
                    onPressed: () => _transferToVault(index),
                    child: Text('Transférer'),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _addVault,
            child: Text('Créer un Nouveau Coffre'),
          ),
        ],
      ),
    );
  }
}
