import 'package:flutter/material.dart';

import '../models/explorer.dart';

class AddExplorerScreen extends StatefulWidget {
  const AddExplorerScreen({super.key});

  @override
  State<AddExplorerScreen> createState() => _AddExplorerScreenState();
}

class _AddExplorerScreenState extends State<AddExplorerScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _track = '';
  int _year = 0;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newExplorer = Explorer(
        name: _name,
        track: _track,
        year: _year,
        skills: [], 
        bio: 'Just joined GDGoC!', 
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Explorer successfully added!')),
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context, newExplorer);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Explorer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter a name' : null,
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Track'),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter a track' : null,
                onSaved: (value) => _track = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter year';
                  if (int.tryParse(value) == null) return 'Please enter a valid number';
                  return null;
                },
                onSaved: (value) => _year = int.parse(value!),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}