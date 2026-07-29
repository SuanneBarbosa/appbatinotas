import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
//import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../../controllers/combinatorics_controller.dart';
import '../../models/music_note.dart';
import 'package:flutter/semantics.dart';
import 'dart:math' as math;
import '../../models/combination_mode.dart';

class ExamplesPanel extends StatelessWidget {
  const ExamplesPanel({super.key});

  String _melodySemanticsLabel(List<MusicNote> melody) {
    return melody.map((note) => note.solfege).join(', ');
  }

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
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _WarningBanner(
              warningId: '${c.mode.label}-${c.n}-${c.beatCount}',
            ),
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
                            button: true,
                            sortKey: OrdinalSortKey(index.toDouble()),
                            label:
                                'Tocar exemplo sonoro ${index + 1}. Notas: ${_melodySemanticsLabel(melody)}.',
                            hint: 'Toque duas vezes para ouvir este exemplo.',
                            onTap: () {
                              context
                                  .read<CombinatoricsController>()
                                  .playExample(index);
                            },
                            child: ExcludeSemantics(
                              child: IconButton.filledTonal(
                                tooltip: 'Tocar exemplo',
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  context
                                      .read<CombinatoricsController>()
                                      .playExample(index);
                                },
                                icon: Icon(
                                  isPlaying
                                      ? Icons.graphic_eq
                                      : Icons.play_arrow,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ExcludeSemantics(
                            child: Row(
                              children: [
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
                                            padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      700
                                                  ? 2
                                                  : 6,
                                            ),
                                            child: _SmallMusicNote(
                                              note: melody[i],
                                              active: c.playingExampleIndex ==
                                                      index &&
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
  final String warningId;

  const _WarningBanner({
    required this.warningId,
  });

  @override
  State<_WarningBanner> createState() => _WarningBannerState();
}

class _WarningBannerState extends State<_WarningBanner> {
  static final Set<String> _playedWarnings = <String>{};

  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playWarningSoundOnce();
    });
  }

  @override
  void didUpdateWidget(covariant _WarningBanner oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.warningId != widget.warningId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _playWarningSoundOnce();
      });
    }
  }

  Future<void> _playWarningSoundOnce() async {
    if (!mounted) return;

    if (_playedWarnings.contains(widget.warningId)) {
      return;
    }

    _playedWarnings.add(widget.warningId);

    try {
      await _player.stop();
      await _player.play(
        AssetSource('sounds/others/errado.mp3'),
      );
    } catch (e) {
      debugPrint('Erro ao tocar som de limite ultrapassado: $e');
    }
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 700;

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
        child: isSmallScreen
            ? Column(
                children: [
                  Image.asset(
                    'assets/images/animacao/alto_falante.gif',
                    height: 120,
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Existem mais possibilidades além das exibidas!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF991B1B),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Image.asset(
                    'assets/images/animacao/alto_falante.gif',
                    height: 110,
                    width: 110,
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Existem mais possibilidades além das exibidas!',
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

class _SmallMusicNote extends StatefulWidget {
  final MusicNote note;
  final bool active;

  const _SmallMusicNote({
    required this.note,
    required this.active,
  });

  @override
  State<_SmallMusicNote> createState() => _SmallMusicNoteState();
}

class _SmallMusicNoteState extends State<_SmallMusicNote>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    if (widget.active) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _SmallMusicNote oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.active && !oldWidget.active) {
      _animationController.repeat(reverse: true);
    }

    if (!widget.active && oldWidget.active) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<CombinatoricsController>().visualizationMode;
    final bool isMobile = MediaQuery.of(context).size.width < 700;

    Widget content;
    Color backgroundColor;
    Border? border;

    double innerHeight;
    double innerMinWidth;
    double innerMaxWidth;
    double outerWidth;
    double outerHeight;
    EdgeInsets innerPadding;
    double borderRadius;

    switch (mode) {
      case ExamplesVisualizationMode.colorWithNumber:
        backgroundColor = widget.note.color;
        border = null;

        innerHeight = isMobile ? 34 : 42;
        innerMinWidth = isMobile ? 34 : 42;
        innerMaxWidth = isMobile ? 38 : 48;

        outerWidth = isMobile ? 44 : 58;
        outerHeight = isMobile ? 44 : 52;

        innerPadding = EdgeInsets.symmetric(
          horizontal: isMobile ? 3 : 8,
          vertical: 5,
        );

        borderRadius = isMobile ? 8 : 10;

        content = Text(
          widget.note.id.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w900,
          ),
        );
        break;

      case ExamplesVisualizationMode.iconWithColor:
        backgroundColor = Colors.transparent;
        border = null;

        innerHeight = isMobile ? 34 : 42;
        innerMinWidth = isMobile ? 26 : 36;
        innerMaxWidth = isMobile ? 30 : 42;

        outerWidth = isMobile ? 38 : 54;
        outerHeight = isMobile ? 44 : 52;

        innerPadding = EdgeInsets.symmetric(
          horizontal: isMobile ? 0 : 4,
          vertical: 5,
        );

        borderRadius = isMobile ? 8 : 10;

        content = Icon(
          Icons.music_note,
          color: widget.note.color,
          size: isMobile ? 25 : 30,
        );
        break;

      case ExamplesVisualizationMode.nameWithColor:
        backgroundColor = widget.note.color;
        border = null;

        innerHeight = isMobile ? 34 : 42;
        innerMinWidth = isMobile ? 42 : 42;
        innerMaxWidth = isMobile ? 54 : 82;

        outerWidth = isMobile ? 62 : 92;
        outerHeight = isMobile ? 44 : 52;

        innerPadding = EdgeInsets.symmetric(
          horizontal: isMobile ? 4 : 8,
          vertical: 5,
        );

        borderRadius = isMobile ? 8 : 10;

        content = Text(
          widget.note.solfege,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 11 : 12,
            fontWeight: FontWeight.w900,
          ),
        );
        break;
    }

    return SizedBox(
      width: outerWidth,
      height: outerHeight,
      child: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final double scale = widget.active
                ? 1.0 + (_animationController.value * (isMobile ? 0.12 : 0.18))
                : 1.0;

            final double rotation = widget.active
                ? math.sin(_animationController.value * math.pi * 2) *
                    (isMobile ? 0.05 : 0.08)
                : 0.0;

            return Transform.rotate(
              angle: rotation,
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            height: innerHeight,
            constraints: BoxConstraints(
              minWidth: innerMinWidth,
              maxWidth: innerMaxWidth,
            ),
            padding: innerPadding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: widget.active
                  ? Border.all(
                      color: Colors.black,
                      width: isMobile ? 2.4 : 3,
                    )
                  : border,
              boxShadow: widget.active
                  ? [
                      BoxShadow(
                        color: widget.note.color.withValues(alpha: 0.45),
                        blurRadius: isMobile ? 7 : 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
