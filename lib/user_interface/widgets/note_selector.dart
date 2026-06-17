import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/combinatorics_controller.dart';
import '../../models/music_note.dart';

class NoteSelector extends StatelessWidget {
  const NoteSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CombinatoricsController>();

    final availableNotes = controller.availableNotes.where((note) {
      return !controller.selectedNotes
          .any((selected) => selected.id == note.id);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (availableNotes.isEmpty)
          const Text(
            'Todas as notas foram escolhidas.',
            style: TextStyle(fontStyle: FontStyle.italic),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = _calculateNoteCardWidth(
                constraints.maxWidth,
              );

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableNotes.map((note) {
                  return Semantics(
                    button: true,
                    selected: false,
                    label: 'Tocar para adicionar a nota ${note.solfege}',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        controller.toggleNote(note);
                        await controller.playSelectedNote(note);
                      },
                      child: _MusicNoteCard(
                        note: note,
                        selected: false,
                        width: cardWidth,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Notas escolhidas:',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'n = ${controller.n}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (controller.selectedNotes.isEmpty)
          const Text(
            'Nenhuma nota escolhida ainda.',
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = _calculateNoteCardWidth(
                constraints.maxWidth,
              );

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.selectedNotes.map((note) {
                  return Semantics(
                    button: true,
                    selected: true,
                    label: 'Tocar para remover a nota ${note.solfege}',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        controller.toggleNote(note);
                        await controller.playSelectedNote(note);
                      },
                      child: _MusicNoteCard(
                        note: note,
                        selected: true,
                        width: cardWidth,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
      ],
    );
  }

  double _calculateNoteCardWidth(double maxWidth) {
    const minWidth = 58.0;
    const maxCardWidth = 86.0;
    const spacing = 8.0;

    int columns;

    if (maxWidth < 360) {
      columns = 4;
    } else if (maxWidth < 520) {
      columns = 5;
    } else if (maxWidth < 760) {
      columns = 6;
    } else {
      columns = 8;
    }

    final totalSpacing = spacing * (columns - 1);
    final width = (maxWidth - totalSpacing) / columns;

    return width.clamp(minWidth, maxCardWidth);
  }
}

class _MusicNoteCard extends StatelessWidget {
  final MusicNote note;
  final bool selected;
  final double width;

  const _MusicNoteCard({
    required this.note,
    required this.selected,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: width,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? Colors.black.withValues(alpha: 0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_note,
                color: note.color,
                size: 16,
              ),
              const SizedBox(width: 2),
              Text(
                note.id.toString(),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            note.solfege,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
