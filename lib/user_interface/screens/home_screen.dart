import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/combinatorics_controller.dart';
import '../widgets/examples_panel.dart';
import '../widgets/formation_mode_selector.dart';
import '../widgets/beat_count_selector.dart';
import '../widgets/note_selector.dart';
import '../widgets/result_panel.dart';
import '../widgets/section_card.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CombinatoricsController>();
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        // title: const Text('CombinaSom Algébrico'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: ListView(
                  children: const [
                    SectionCard(
                      title: '',
                      child: FormationModeSelector(),
                    ),
                    SectionCard(
                      title: 'Notas musicais (n)',
                      child: NoteSelector(),
                    ),
                    SectionCard(
                      title: 'Número de batidas (b)',
                      child: BeatCountSelector(),
                    ),
                    SectionCard(
                      title: 'Exemplos sonoros',
                      child: ExamplesPanel(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: ListView(
                  children: const [
                    SectionCard(
                      title: 'Resultados',
                      child: ResultPanel(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
