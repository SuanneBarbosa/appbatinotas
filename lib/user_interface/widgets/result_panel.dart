import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../../controllers/combinatorics_controller.dart';

class ResultPanel extends StatelessWidget {
  const ResultPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CombinatoricsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _VariablesSummary(
          noteCount: c.n,
          beatCount: c.beatCount,
        ),
        const SizedBox(height: 14),
        _AnswerField(
          label: 'Quantas músicas você encontrou?',
          value: c.studentFoundTotal,
          minLines: 1,
          maxLines: 2,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          semanticsHint:
              'Digite a quantidade de músicas que você encontrou. Use o botão de alto-falante para ouvir sua resposta.',
          onChanged:
              context.read<CombinatoricsController>().setStudentFoundTotal,
        ),
        const SizedBox(height: 12),
        _AnswerField(
          label: 'Qual cálculo você utilizou para encontrar esse valor?',
          value: c.studentCalculation,
          minLines: 2,
          maxLines: 3,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          semanticsHint:
              'Digite o cálculo utilizado para encontrar a quantidade de músicas. Use o botão de alto-falante para ouvir sua resposta.',
          onChanged:
              context.read<CombinatoricsController>().setStudentCalculation,
        ),
        const SizedBox(height: 12),
        _AnswerField(
          label: 'Escreva a regra geral que representa esse tipo de situação.',
          value: c.studentGeneralRule,
          minLines: 2,
          maxLines: 3,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          semanticsHint:
              'Digite a regra geral que representa a situação. Use o botão de alto-falante para ouvir sua resposta.',
          onChanged:
              context.read<CombinatoricsController>().setStudentGeneralRule,
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () async {
              await context
                  .read<CombinatoricsController>()
                  .saveCurrentActivity();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Atividade salva na galeria!'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.save),
            label: const Text('Salvar atividade'),
          ),
        ),
      ],
    );
  }
}

class _VariablesSummary extends StatelessWidget {
  final int noteCount;
  final int beatCount;

  const _VariablesSummary({
    required this.noteCount,
    required this.beatCount,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compact = constraints.maxWidth < 420;

        return Row(
          children: [
            Expanded(
              child: _VariableCard(
                symbol: 'n',
                value: noteCount.toString(),
                label: compact ? 'notas' : 'notas escolhidas',
                icon: Icons.music_note,
                color: const Color(0xFF2563EB),
                compact: compact,
              ),
            ),
            SizedBox(width: compact ? 8 : 12),
            Expanded(
              child: _VariableCard(
                symbol: 'b',
                value: beatCount.toString(),
                label: 'batidas',
                icon: Icons.timer,
                color: const Color(0xFF0F766E),
                compact: compact,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _VariableCard extends StatelessWidget {
  final String symbol;
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final bool compact;

  const _VariableCard({
    required this.symbol,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: compact ? 68 : 84,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 14,
        vertical: compact ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(compact ? 14 : 18),
        border: Border.all(
          color: color.withValues(alpha: 0.45),
          width: 1.4,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 26 : 32,
            height: compact ? 26 : 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(compact ? 8 : 10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: compact ? 14 : 17,
            ),
          ),
          SizedBox(width: compact ? 8 : 12),
          Expanded(
            child: RichText(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                ),
                children: [
                  TextSpan(
                    text: symbol,
                    style: TextStyle(
                      fontSize: compact ? 24 : 34,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                  TextSpan(
                    text: ' = ',
                    style: TextStyle(
                      fontSize: compact ? 18 : 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: compact ? 22 : 30,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                  TextSpan(
                    text: '\n$label',
                    style: TextStyle(
                      fontSize: compact ? 11 : 13,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerField extends StatefulWidget {
  final String label;
  final String value;
  final int minLines;
  final int maxLines;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String semanticsHint;
  final ValueChanged<String> onChanged;

  const _AnswerField({
    required this.label,
    required this.value,
    required this.minLines,
    required this.maxLines,
    required this.keyboardType,
    required this.textInputAction,
    required this.semanticsHint,
    required this.onChanged,
  });

  @override
  State<_AnswerField> createState() => _AnswerFieldState();
}

class _AnswerFieldState extends State<_AnswerField> {
  late final TextEditingController _controller;
  late final FlutterTts _tts;

  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.value);

    _tts = FlutterTts();
    _configureTts();
  }

  Future<void> _configureTts() async {
    await _tts.setLanguage('pt-BR');
    await _tts.setSpeechRate(0.48);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    _tts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });

    _tts.setCancelHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });

    _tts.setErrorHandler((message) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });
  }

  Future<void> _toggleSpeak() async {
    if (_isSpeaking) {
      await _tts.stop();

      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }

      return;
    }

    final answer = _controller.text.trim();

    final textToSpeak = answer.isEmpty
        ? 'Nenhuma resposta foi digitada no campo: ${widget.label}'
        : 'Resposta do campo ${widget.label}: $answer';

    setState(() {
      _isSpeaking = true;
    });

    await _tts.speak(textToSpeak);
  }

  @override
  void didUpdateWidget(covariant _AnswerField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: 'Campo de resposta. ${widget.label}',
      hint: widget.semanticsHint,
      child: TextField(
        controller: _controller,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          alignLabelWithHint: true,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          suffixIcon: Semantics(
            button: true,
            label: _isSpeaking
                ? 'Parar leitura da resposta'
                : 'Falar resposta digitada',
            child: IconButton(
              tooltip:
                  _isSpeaking ? 'Parar leitura' : 'Falar resposta digitada',
              onPressed: _toggleSpeak,
              icon: Icon(
                _isSpeaking ? Icons.stop_circle : Icons.volume_up,
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFE2E8F0),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF111827),
              width: 3,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _controller.dispose();
    super.dispose();
  }
}
