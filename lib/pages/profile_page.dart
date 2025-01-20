import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<String> _categories = ['Nourriture', 'Transport', 'Loisirs', 'Salaire', 'Autre'];

  @override
  void initState() {
    super.initState();
    // Initialiser les données personnelles (exemple fictif)
    _nameController.text = 'Jean Dupont';
    _emailController.text = 'jean.dupont@example.com';
  }

  void _addCategory() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController categoryController = TextEditingController();
        return AlertDialog(
          title: const Text('Ajouter une catégorie'),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(
              labelText: 'Nom de la catégorie',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  setState(() {
                    _categories.add(categoryController.text);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _editCategory(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController categoryController =
            TextEditingController(text: _categories[index]);
        return AlertDialog(
          title: const Text('Modifier la catégorie'),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(
              labelText: 'Nom de la catégorie',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  setState(() {
                    _categories[index] = categoryController.text;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(int index) {
    setState(() {
      _categories.removeAt(index);
    });
  }

  void _saveProfile() {
    // Logique pour sauvegarder les modifications (exemple : sauvegarde dans Firebase)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil sauvegardé avec succès !')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Informations personnelles
            const Text(
              'Informations personnelles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            // Gestion des catégories
            const Text(
              'Catégories financières',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_categories[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editCategory(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCategory(index),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _addCategory,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter une catégorie'),
            ),
            const SizedBox(height: 24),
            // Bouton pour sauvegarder le profil
            Center(
              child: ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.save),
                label: const Text('Sauvegarder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
