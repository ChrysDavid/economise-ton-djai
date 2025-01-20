import 'package:bgre_ton_djai/pages/aving_techniques_page.dart';
import 'package:bgre_ton_djai/pages/monthly_summary_page.dart';
import 'package:bgre_ton_djai/pages/profile_page.dart';
import 'package:bgre_ton_djai/pages/transaction_history_page.dart';
import 'package:bgre_ton_djai/pages/vault_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Liste des pages accessibles
  final List<Widget> _pages = [
    const TransactionHistoryPage(), // Historique des transactions
    const VaultPage(),              // Gestion des coffres
    MonthlySummaryPage(),     // Résumé mensuel
    SavingTechniquesPage(),   // Techniques d'économie
    const ProfilePage(),            // Profil
  ];

  // Liste des titres correspondants
  final List<String> _titles = [
    'Historique',
    'Coffres',
    'Résumé Mensuel',
    'Économie',
    'Profil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Coffres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf),
            label: 'Résumé',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Économie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
