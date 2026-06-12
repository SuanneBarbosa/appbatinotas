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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Semantics(
                label: 'Número de batidas atual: ${controller.beatCount}',
                child: Text(
                  '${controller.beatCount}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
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
