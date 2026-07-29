import 'package:flutter/material.dart';

import '../widgets/examples_panel.dart';
import '../widgets/formation_mode_selector.dart';
import '../widgets/beat_count_selector.dart';
import '../widgets/note_selector.dart';
import '../widgets/result_panel.dart';
import '../widgets/section_card.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey? menuKey;
  final GlobalKey? notesKey;
  final GlobalKey? modeKey;
  final GlobalKey? beatKey;
  final GlobalKey? examplesKey;
  final GlobalKey? resultKey;
  final GlobalKey? symbolsKey;
  final GlobalKey? clearKey;
  final GlobalKey? saveKey;

  const HomeScreen({
    super.key,
    this.menuKey,
    this.notesKey,
    this.modeKey,
    this.beatKey,
    this.examplesKey,
    this.resultKey,
    this.symbolsKey,
    this.clearKey,
    this.saveKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 30,
        titleSpacing: 0,
        leadingWidth: 38,
        iconTheme: const IconThemeData(
          size: 24,
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              key: menuKey,
              tooltip: 'Abrir menu lateral',
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: ListView(
                children: [
                  KeyedSubtree(
                    key: notesKey,
                    child: const SectionCard(
                      title: 'Notas musicais (n)',
                      child: NoteSelector(),
                    ),
                  ),
                  KeyedSubtree(
                    key: modeKey,
                    child: const SectionCard(
                      title: '',
                      child: FormationModeSelector(),
                    ),
                  ),
                  KeyedSubtree(
                    key: beatKey,
                    child: const SectionCard(
                      title: '',
                      child: BeatCountSelector(),
                    ),
                  ),
                  KeyedSubtree(
                    key: examplesKey,
                    child: const SectionCard(
                      title: 'Combinações',
                      child: ExamplesPanel(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 4,
              child: ListView(
                children: [
                  KeyedSubtree(
                    key: resultKey,
                    child: SectionCard(
                      title: 'Resultados',
                      child: ResultPanel(
                        symbolsKey: symbolsKey,
                        clearKey: clearKey,
                        saveKey: saveKey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
