import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/combinatorics_controller.dart';
import '../../models/combination_mode.dart';

class ModeControls extends StatelessWidget {
  const ModeControls({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CombinatoricsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de formação das músicas',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        SegmentedButton<CombinationMode>(
          segments: const [
            ButtonSegment(
              value: CombinationMode.withRepetition,
              label: Text('Com repetição'),
              icon: Icon(Icons.repeat),
            ),
            ButtonSegment(
              value: CombinationMode.withoutRepetition,
              label: Text('Sem repetição'),
              icon: Icon(Icons.block),
            ),
          ],
          selected: {controller.mode},
          onSelectionChanged: (value) => controller.setMode(value.first),
        ),
        const SizedBox(height: 18),
        const Text(
          'Número de batidas da música',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: () =>
                  controller.setBeatCount(controller.beatCount - 1),
              icon: const Icon(Icons.remove),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                '${controller.beatCount}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            IconButton.filledTonal(
              onPressed: () =>
                  controller.setBeatCount(controller.beatCount + 1),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
