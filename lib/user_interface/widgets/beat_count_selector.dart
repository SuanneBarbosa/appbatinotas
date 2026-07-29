import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/combinatorics_controller.dart';

class BeatCountSelector extends StatelessWidget {
  const BeatCountSelector({super.key});

  static const Color _bColor = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CombinatoricsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.timer, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Número de batidas:',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'b = ${controller.b}',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: _bColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              button: true,
              label: 'Diminuir número de batidas',
              child: IconButton.filledTonal(
                onPressed: () {
                  controller.setBeatCount(controller.beatCount - 1);
                },
                icon: const Icon(Icons.remove),
              ),
            ),
            const SizedBox(width: 18),
            Semantics(
              label: 'Número de batidas atual: ${controller.beatCount}',
              child: Text(
                '${controller.beatCount}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: _bColor,
                    ),
              ),
            ),
            const SizedBox(width: 18),
            Semantics(
              button: true,
              label: 'Aumentar número de batidas',
              child: IconButton.filledTonal(
                onPressed: () {
                  controller.setBeatCount(controller.beatCount + 1);
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
