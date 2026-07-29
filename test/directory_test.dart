import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gdgoc_explorer_directory/main.dart';
import 'package:gdgoc_explorer_directory/data/sample_explorers.dart';
import 'package:gdgoc_explorer_directory/models/explorer.dart';
import 'package:gdgoc_explorer_directory/screens/explorer_list_screen.dart';
import 'package:gdgoc_explorer_directory/screens/explorer_detail_screen.dart';
import 'package:gdgoc_explorer_directory/screens/add_explorer_screen.dart';

void main() {
  // ─── Test Group 1: App rendering & theming ─────────────────────────────

  group('App Rendering', () {
    testWidgets('app contains MaterialApp with ThemeData', (tester) async {
      await tester.pumpWidget(const GDGoCExplorerApp());

      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      expect(materialApp.theme, isNotNull,
          reason: 'MaterialApp must have a custom ThemeData');
    });

    testWidgets('app title is "GDGoC Explorer Directory"', (tester) async {
      await tester.pumpWidget(const GDGoCExplorerApp());

      final materialApp = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      expect(materialApp.title, 'GDGoC Explorer Directory');
    });
  });

  // ─── Test Group 2: List screen ─────────────────────────────────────────

  group('Explorer List Screen', () {
    testWidgets('displays AppBar with title "Explorer Directory"',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ExplorerListScreen(explorers: sampleExplorers)),
      );

      expect(find.text('Explorer Directory'), findsOneWidget);
    });

    testWidgets('uses ListView.builder to display explorers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ExplorerListScreen(explorers: sampleExplorers)),
      );

      expect(find.byType(ListView), findsOneWidget,
          reason: 'List screen must use ListView (ListView.builder)');
    });

    testWidgets('displays all sample explorers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ExplorerListScreen(explorers: sampleExplorers)),
      );

      for (final explorer in sampleExplorers) {
        expect(find.text(explorer.name), findsWidgets,
            reason: 'Explorer "${explorer.name}" should be visible');
      }
    });

    testWidgets('has an add-explorer action button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ExplorerListScreen(explorers: sampleExplorers)),
      );

      expect(find.byIcon(Icons.person_add), findsOneWidget,
          reason: 'AppBar must have an Icons.person_add action button');
    });
  });

  // ─── Test Group 3: Navigation to detail ────────────────────────────────

  group('Navigation to Detail', () {
    testWidgets('tapping an explorer navigates to detail screen',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ExplorerListScreen(explorers: sampleExplorers)),
      );

      // Tap the first explorer name
      await tester.tap(find.text(sampleExplorers[0].name).first);
      await tester.pumpAndSettle();

      // Detail screen should be present
      expect(find.byType(ExplorerDetailScreen), findsOneWidget,
          reason: 'Tapping an explorer should navigate to ExplorerDetailScreen');

      // Detail screen AppBar should show the explorer's name
      expect(find.text(sampleExplorers[0].name), findsWidgets);
    });
  });

  // ─── Test Group 4: Detail screen content ───────────────────────────────

  group('Explorer Detail Screen', () {
    testWidgets('displays explorer name, track, and year', (tester) async {
      final explorer = sampleExplorers[0];
      await tester.pumpWidget(
        MaterialApp(home: ExplorerDetailScreen(explorer: explorer)),
      );

      expect(find.text(explorer.name), findsWidgets);
      expect(find.text(explorer.track), findsOneWidget);
      expect(find.textContaining('Year'), findsWidgets,
          reason: 'Detail screen should display the explorer\'s year');
    });

    testWidgets('displays skills as Chip widgets inside a Wrap',
        (tester) async {
      final explorer = sampleExplorers[0];
      await tester.pumpWidget(
        MaterialApp(home: ExplorerDetailScreen(explorer: explorer)),
      );

      expect(find.byType(Wrap), findsOneWidget,
          reason: 'Skills should be displayed in a Wrap widget');
      expect(find.byType(Chip), findsNWidgets(explorer.skills.length),
          reason: 'Each skill should be a Chip widget');
    });

    testWidgets('shows bio or fallback when bio is null', (tester) async {
      // Test with bio
      final explorerWithBio = sampleExplorers[0];
      await tester.pumpWidget(
        MaterialApp(home: ExplorerDetailScreen(explorer: explorerWithBio)),
      );
      expect(find.text(explorerWithBio.bio!), findsOneWidget);

      // Test without bio (Citra Pratama has bio: null)
      final explorerWithoutBio = sampleExplorers[2];
      await tester.pumpWidget(
        MaterialApp(home: ExplorerDetailScreen(explorer: explorerWithoutBio)),
      );
      expect(find.text('No bio provided.'), findsOneWidget,
          reason: 'When bio is null, should show fallback message');
    });
  });

  // ─── Test Group 5: Add Explorer form ───────────────────────────────────

  group('Add Explorer Form', () {
    testWidgets('has a Form with TextFormField widgets', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: AddExplorerScreen()),
      );

      expect(find.byType(Form), findsOneWidget,
          reason: 'Form widget must be present');
      expect(find.byType(TextFormField), findsNWidgets(3),
          reason: 'There must be 3 TextFormField widgets (name, track, year)');
    });

    testWidgets('has a submit button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: AddExplorerScreen()),
      );

      expect(find.byType(ElevatedButton), findsOneWidget,
          reason: 'A submit ElevatedButton must be present');
    });

    testWidgets('shows validation error when fields are empty',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: AddExplorerScreen()),
      );

      // Tap submit without filling anything
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // At least one validation error should appear
      expect(find.byType(Text), findsWidgets,
          reason: 'Validation errors should be shown');
    });

    testWidgets('shows SnackBar on successful form submission',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: AddExplorerScreen()),
      );

      // Fill in name
      await tester.enterText(find.byType(TextFormField).at(0), 'Test Explorer');
      // Fill in track
      await tester.enterText(find.byType(TextFormField).at(1), 'Mobile Development');
      // Fill in year
      await tester.enterText(find.byType(TextFormField).at(2), '3');

      // Tap submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // SnackBar should appear
      expect(find.byType(SnackBar), findsOneWidget,
          reason: 'A SnackBar should appear on successful submission');
    });

    testWidgets('returns an Explorer object on successful submission',
        (tester) async {
      Explorer? returnedExplorer;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                final result = await Navigator.of(context).push<Explorer>(
                  MaterialPageRoute(
                    builder: (context) => const AddExplorerScreen(),
                  ),
                );
                returnedExplorer = result;
              },
              child: const Text('Open Form'),
            ),
          ),
        ),
      );

      // Open the form
      await tester.tap(find.text('Open Form'));
      await tester.pumpAndSettle();

      // Fill in the form
      await tester.enterText(find.byType(TextFormField).at(0), 'New Explorer');
      await tester.enterText(find.byType(TextFormField).at(1), 'Web Development');
      await tester.enterText(find.byType(TextFormField).at(2), '2');

      // Submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(returnedExplorer, isNotNull,
          reason: 'AddExplorerScreen should return an Explorer via Navigator.pop');
      expect(returnedExplorer!.name, 'New Explorer');
      expect(returnedExplorer!.track, 'Web Development');
      expect(returnedExplorer!.year, 2);
    });
  });
}
