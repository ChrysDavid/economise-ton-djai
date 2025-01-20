import 'package:flutter/material.dart';

class VaultPage extends StatefulWidget {
  const VaultPage({Key? key}) : super(key: key);

  @override
  _VaultPageState createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  final List<Map<String, dynamic>> _vaults = [
    {'name': 'Vacances', 'currentAmount': 500.0, 'goal': 1000.0},
    {'name': 'Urgences', 'currentAmount': 300.0, 'goal': 500.0},
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vaultNameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();

  void _addVault() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _vaults.add({
          'name': _vaultNameController.text,
          'currentAmount': 0.0,
          'goal': double.parse(_goalController.text),
        });
      });
      _vaultNameController.clear();
      _goalController.clear();
      Navigator.pop(context);
    }
  }

  void _transferMoney(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController transferController = TextEditingController();
        return AlertDialog(
          title: const Text('Transférer de l\'argent'),
          content: TextField(
            controller: transferController,
            decoration: const InputDecoration(
              labelText: 'Montant à transférer',
              hintText: 'Exemple : 100.0',
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final double transferAmount =
                    double.tryParse(transferController.text) ?? 0.0;
                if (transferAmount > 0) {
                  setState(() {
                    _vaults[index]['currentAmount'] += transferAmount;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Transférer'),
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
        title: const Text('Gestion des Coffres'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Liste des coffres
            Expanded(
              child: ListView.builder(
                itemCount: _vaults.length,
                itemBuilder: (context, index) {
                  final vault = _vaults[index];
                  final progress = (vault['currentAmount'] / vault['goal']).clamp(0.0, 1.0);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(vault['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Montant actuel : \$${vault['currentAmount'].toStringAsFixed(2)}'),
                          Text('Objectif : \$${vault['goal'].toStringAsFixed(2)}'),
                          LinearProgressIndicator(value: progress),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.swap_horiz),
                        onPressed: () => _transferMoney(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Bouton pour ajouter un coffre
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Ajouter un Coffre'),
                      content: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _vaultNameController,
                              decoration: const InputDecoration(
                                labelText: 'Nom du coffre',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer un nom.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _goalController,
                              decoration: const InputDecoration(
                                labelText: 'Objectif (en \$)',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer un objectif.';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Veuillez entrer un nombre valide.';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Annuler'),
                        ),
                        ElevatedButton(
                          onPressed: _addVault,
                          child: const Text('Ajouter'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un Coffre'),
            ),
          ],
        ),
      ),
    );
  }
}
