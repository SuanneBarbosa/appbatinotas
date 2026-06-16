import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
        if (!c.shouldListAll && c.examples.isNotEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: _WarningBanner(),
          ),
        LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallScreen = constraints.maxWidth < 650;
            const double spacing = 10;
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
                          child: Semantics(
                            label: 'Ouvir este exemplo sonoro',
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

class _WarningBanner extends StatefulWidget {
  const _WarningBanner();

  @override
  State<_WarningBanner> createState() => _WarningBannerState();
}

class _WarningBannerState extends State<_WarningBanner> {
  late final FlutterTts _tts;

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('pt-BR');
    await _tts.setSpeechRate(0.48);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    if (mounted) {
      await _tts.speak("Limite Ultrapassado! Existem mais possibilidades além das exibidas.");
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.8, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFEF4444).withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFEF4444),
              size: 28,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Limite Ultrapassado! Existem mais possibilidades além das exibidas.',
                style: TextStyle(
                  color: Color(0xFF991B1B),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
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
    final mode = context.watch<CombinatoricsController>().visualizationMode;

    Widget content;
    switch (mode) {
      case ExamplesVisualizationMode.colorWithNumber:
        content = Text(
          note.id.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        );
        break;
      case ExamplesVisualizationMode.iconWithColor:
        content = const Icon(
          Icons.music_note,
          color: Colors.white,
          size: 20,
        );
        break;
      case ExamplesVisualizationMode.nameWithColor:
        content = Text(
          note.solfege,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        );
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      height: 42,
      constraints: const BoxConstraints(
        minWidth: 42,
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
        child: content,
      ),
    );
  }
}
