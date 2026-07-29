import 'package:flutter/material.dart';

import 'screens/explorer_list_screen.dart';
import 'data/sample_explorers.dart';

void main() {
  runApp(const GDGoCExplorerApp());
}

class GDGoCExplorerApp extends StatelessWidget {
  const GDGoCExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GDGoC Explorer Directory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00A19C)),
        useMaterial3: true,
      ),
      home: ExplorerListScreen(explorers: sampleExplorers),
    );
  }
}