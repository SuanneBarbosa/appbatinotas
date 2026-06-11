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
                    label: '${note.semanticsLabel}. Não selecionada',
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
          children: [
            const Icon(Icons.check_circle, size: 20),
            const SizedBox(width: 8),
            Text(
              'Notas escolhidas: ${controller.n}',
              style: const TextStyle(fontWeight: FontWeight.w900),
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
                    label: '${note.semanticsLabel}. Selecionada',
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
    final backgroundColor =
        selected ? note.color : note.color.withValues(alpha: 0.18);

    final foregroundColor = selected ? Colors.white : Colors.black87;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: width,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? Colors.black87 : note.color,
          width: selected ? 2.5 : 1.2,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: note.color.withValues(alpha: 0.22),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Center(
        child: Text(
          note.solfege,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: foregroundColor,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
