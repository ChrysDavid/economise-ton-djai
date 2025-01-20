import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class MonthlySummaryPage extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {'name': 'Course', 'amount': -50.0, 'category': 'Nourriture', 'date': '2025-01-18'},
    {'name': 'Salaire', 'amount': 2000.0, 'category': 'Salaire', 'date': '2025-01-15'},
    {'name': 'Restaurant', 'amount': -35.0, 'category': 'Loisirs', 'date': '2025-01-14'},
    {'name': 'Transport', 'amount': -15.0, 'category': 'Transport', 'date': '2025-01-14'},
    {'name': 'Cadeau', 'amount': -100.0, 'category': 'Autre', 'date': '2025-01-13'},
  ];

  MonthlySummaryPage({Key? key}) : super(key: key);

  // Calcul des totaux
  Map<String, double> _calculateSummary() {
    double totalIncome = 0;
    double totalExpenses = 0;

    for (var transaction in transactions) {
      if (transaction['amount'] > 0) {
        totalIncome += transaction['amount'];
      } else {
        totalExpenses += transaction['amount'].abs();
      }
    }

    return {
      'income': totalIncome,
      'expenses': totalExpenses,
    };
  }

  // Calcul des dépenses par catégorie
  Map<String, double> _calculateExpensesByCategory() {
    final Map<String, double> expensesByCategory = {};

    for (var transaction in transactions) {
      if (transaction['amount'] < 0) {
        expensesByCategory[transaction['category']] =
            (expensesByCategory[transaction['category']] ?? 0) +
                transaction['amount'].abs();
      }
    }

    return expensesByCategory;
  }

  // Générer le PDF
  Future<void> _generatePDF(BuildContext context) async {
    final summary = _calculateSummary();
    final expensesByCategory = _calculateExpensesByCategory();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Résumé Mensuel', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Total des revenus : \$${summary['income']?.toStringAsFixed(2)}'),
              pw.Text('Total des dépenses : \$${summary['expenses']?.toStringAsFixed(2)}'),
              pw.SizedBox(height: 16),
              pw.Text('Dépenses par catégorie :', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ...expensesByCategory.entries.map(
                (entry) => pw.Text('${entry.key} : \$${entry.value.toStringAsFixed(2)}'),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'Astuce : Essayez de réduire vos dépenses inutiles pour économiser davantage.',
                style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
              ),
            ],
          );
        },
      ),
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/resume_mensuel.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF généré : ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la génération du PDF : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = _calculateSummary();
    final expensesByCategory = _calculateExpensesByCategory();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Résumé Mensuel'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Résumé des totaux
            const Text(
              'Résumé',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Total des revenus : \$${summary['income']?.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            Text(
              'Total des dépenses : \$${summary['expenses']?.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const Divider(),
            // Dépenses par catégorie
            const Text(
              'Dépenses par catégorie',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...expensesByCategory.entries.map(
              (entry) => ListTile(
                title: Text(entry.key),
                trailing: Text('\$${entry.value.toStringAsFixed(2)}'),
              ),
            ),
            const Divider(),
            // Génération du PDF
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _generatePDF(context),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Générer PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
