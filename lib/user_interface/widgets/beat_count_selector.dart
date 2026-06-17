import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/combinatorics_controller.dart';

class BeatCountSelector extends StatelessWidget {
  const BeatCountSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CombinatoricsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Semantics(
                  label: 'Número de batidas atual: ${controller.beatCount}',
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Número de batidas:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'b = ${controller.beatCount}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFF59E0B),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
