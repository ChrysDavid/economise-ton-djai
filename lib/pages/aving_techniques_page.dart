import 'package:flutter/material.dart';

class SavingTechniquesPage extends StatelessWidget {
  final List<Map<String, dynamic>> expenseAnalysis = [
    {'category': 'Nourriture', 'amount': 400.0, 'percentage': 40},
    {'category': 'Transport', 'amount': 200.0, 'percentage': 20},
    {'category': 'Loisirs', 'amount': 150.0, 'percentage': 15},
    {'category': 'Factures', 'amount': 250.0, 'percentage': 25},
  ];

  final List<String> savingTips = [
    'Fixez un budget mensuel pour chaque catégorie.',
    'Évitez les achats impulsifs en établissant une liste de priorités.',
    'Utilisez des applications pour suivre vos dépenses.',
    'Economisez au moins 20 % de votre revenu chaque mois.',
    'Cherchez des offres et réductions avant d’acheter.',
  ];

  SavingTechniquesPage({Key? key}) : super(key: key);

  /// Analyse Pareto (80/20)
  Widget _buildParetoAnalysis() {
    final total = expenseAnalysis.fold<double>(
      0,
      (sum, expense) => sum + expense['amount'],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Analyse Pareto (80/20)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...expenseAnalysis.map((expense) {
          final percentageOfTotal =
              ((expense['amount'] / total) * 100).toStringAsFixed(1);
          return ListTile(
            title: Text(expense['category']),
            subtitle: Text('Montant : \$${expense['amount'].toStringAsFixed(2)}'),
            trailing: Text('$percentageOfTotal %'),
          );
        }).toList(),
        const SizedBox(height: 16),
        const Text(
          'Astuce : Concentrez-vous sur les 20 % des dépenses qui représentent 80 % de vos coûts totaux.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  /// Liste des conseils d'économie
  Widget _buildSavingTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Conseils d’économie',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...savingTips.map((tip) => ListTile(
              leading: const Icon(Icons.lightbulb_outline, color: Colors.orange),
              title: Text(tip),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Techniques d’économie'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Analyse Pareto
            _buildParetoAnalysis(),
            const Divider(),
            // Conseils d'économie
            _buildSavingTips(),
            const Divider(),
            // Notification de rappel
            const Text(
              'Notifications et rappels',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.blue),
              title: const Text(
                'Activez les rappels pour surveiller vos dépenses inutiles.',
              ),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Ajouter la logique pour activer ou désactiver les notifications
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(value
                          ? 'Notifications activées'
                          : 'Notifications désactivées'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
