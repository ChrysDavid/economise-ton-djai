import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  final bool isExpense; // Détermine si c'est une dépense ou un revenu.

  const TransactionPage({Key? key, required this.isExpense}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  // Liste des catégories
  final List<String> _categories = [
    'Nourriture',
    'Transport',
    'Loisirs',
    'Salaire',
    'Autre',
  ];

  // Méthode pour choisir une date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Méthode pour sauvegarder la transaction
  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      // Créer l'objet transaction
      final transaction = {
        'name': _nameController.text,
        'amount': double.parse(_amountController.text),
        'category': _selectedCategory ?? 'Autre',
        'date': _selectedDate.toString(),
        'type': widget.isExpense ? 'Dépense' : 'Revenu',
      };

      // Exemple : Afficher dans la console
      print('Transaction enregistrée : $transaction');

      // Retourner à la page précédente
      Navigator.pop(context, transaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isExpense ? 'Ajouter une dépense' : 'Ajouter un revenu'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Champ pour le nom
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  hintText: 'Exemple : Restaurant, Salaire...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Champ pour le montant
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Montant',
                  hintText: 'Exemple : 50.0',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un montant.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Sélection de la catégorie
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Sélecteur de date
              Row(
                children: [
                  Text(
                    'Date : ${_selectedDate.toLocal()}'.split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _pickDate(context),
                    child: const Text('Choisir une date'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Bouton pour enregistrer
              Center(
                child: ElevatedButton.icon(
                  onPressed: _saveTransaction,
                  icon: const Icon(Icons.save),
                  label: const Text('Enregistrer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
