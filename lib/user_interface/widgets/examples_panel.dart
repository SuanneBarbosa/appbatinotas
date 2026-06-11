import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/combinatorics_controller.dart';
import '../../models/music_note.dart';

class ExamplesPanel extends StatelessWidget {
  const ExamplesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CombinatoricsController>();

    if (c.examples.isEmpty) {
      return const Text(
        'Nenhum exemplo para mostrar.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallScreen = constraints.maxWidth < 650;
            final double spacing = 10;
            final double itemWidth = isSmallScreen
                ? constraints.maxWidth
                : (constraints.maxWidth - spacing) / 2;

            return Wrap(
              spacing: spacing,
              runSpacing: 10,
              children: List.generate(c.examples.length, (index) {
                final melody = c.examples[index];
                final isPlaying = c.playingExampleIndex == index;

                return SizedBox(
                  width: itemWidth,
                  child: Container(
                    height: 72,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isPlaying ? const Color(0xFFEEF2FF) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isPlaying
                            ? const Color(0xFF4F46E5)
                            : const Color(0xFFE2E8F0),
                        width: isPlaying ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 34,
                          height: 34,
                          child: IconButton.filledTonal(
                            tooltip: 'Tocar exemplo',
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              context
                                  .read<CombinatoricsController>()
                                  .playExample(index);
                            },
                            icon: Icon(
                              isPlaying ? Icons.graphic_eq : Icons.play_arrow,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${index + 1}.',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (int i = 0; i < melody.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: _SmallMusicNote(
                                      note: melody[i],
                                      active: c.playingExampleIndex == index &&
                                          c.playingNoteIndex == i,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}

class _SmallMusicNote extends StatelessWidget {
  final MusicNote note;
  final bool active;

  const _SmallMusicNote({
    required this.note,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      height: 42,
      constraints: const BoxConstraints(
        minWidth: 54,
        maxWidth: 82,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: note.color,
        borderRadius: BorderRadius.circular(10),
        border: active
            ? Border.all(
                color: Colors.black,
                width: 3,
              )
            : null,
      ),
      child: Center(
        child: Text(
          note.solfege,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
