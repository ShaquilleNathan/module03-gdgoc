import 'package:flutter/material.dart';

import '../models/explorer.dart';
import 'explorer_detail_screen.dart';
import 'add_explorer_screen.dart';

class ExplorerListScreen extends StatefulWidget {
  final List<Explorer> explorers;

  const ExplorerListScreen({super.key, required this.explorers});

  @override
  State<ExplorerListScreen> createState() => _ExplorerListScreenState();
}

class _ExplorerListScreenState extends State<ExplorerListScreen> {
  late List<Explorer> _explorers;

  @override
  void initState() {
    super.initState();
    _explorers = List.from(widget.explorers);
  }

  void _addExplorer(Explorer explorer) {
    setState(() {
      _explorers.add(explorer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorer Directory'), 
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add), 
            onPressed: () async {
              final newExplorer = await Navigator.push<Explorer>(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddExplorerScreen(),
                ),
              );
              
              if (newExplorer != null) {
                _addExplorer(newExplorer);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _explorers.length,
        itemBuilder: (context, index) {
          final explorer = _explorers[index];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(explorer.name),
            subtitle: Text(explorer.track),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExplorerDetailScreen(explorer: explorer),
                ),
              );
            },
          );
        },
      ),
    );
  }
}