import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../../controllers/combinatorics_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ResultPanel extends StatefulWidget {
  final GlobalKey? symbolsKey;
  final GlobalKey? clearKey;
  final GlobalKey? saveKey;

  const ResultPanel({
    super.key,
    this.symbolsKey,
    this.clearKey,
    this.saveKey,
  });

  @override
  State<ResultPanel> createState() => _ResultPanelState();
}

class _ResultPanelState extends State<ResultPanel> {
  final GlobalKey<_AnswerFieldState> _generalRuleFieldKey =
      GlobalKey<_AnswerFieldState>();

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
          sortOrder: 1,
          onChanged:
              context.read<CombinatoricsController>().setStudentFoundTotal,
        ),
        const SizedBox(height: 12),
        _AnswerField(
          key: _generalRuleFieldKey,
          label: 'Escreva a regra geral.',
          value: c.studentGeneralRule,
          minLines: 2,
          maxLines: 3,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          semanticsHint:
              'Digite a regra geral que representa a situação. Use o botão de símbolos para inserir símbolos matemáticos.',
          sortOrder: 2,
          showMathSymbols: true,
          symbolsKey: widget.symbolsKey,
          onChanged:
              context.read<CombinatoricsController>().setStudentGeneralRule,
        ),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.center,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              KeyedSubtree(
                key: widget.clearKey,
                child: Semantics(
                  container: true,
                  button: true,
                  sortKey: const OrdinalSortKey(3),
                  label: 'Limpar todos os campos de resposta',
                  child: ExcludeSemantics(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context
                            .read<CombinatoricsController>()
                            .clearStudentAnswers();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Campos de resposta limpos!'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.cleaning_services_outlined),
                      label: const Text('Limpar'),
                    ),
                  ),
                ),
              ),
              KeyedSubtree(
                key: widget.saveKey,
                child: Semantics(
                  container: true,
                  button: true,
                  sortKey: const OrdinalSortKey(4),
                  label: 'Salvar a atividade atual na galeria',
                  child: ExcludeSemantics(
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
                      label: const Text('Salvar'),
                    ),
                  ),
                ),
              ),
            ],
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
                color: const Color(0xFF8B5CF6),
                compact: compact,
              ),
            ),
            SizedBox(width: compact ? 8 : 12),
            Expanded(
              child: _VariableCard(
                symbol: 'b',
                value: beatCount.toString(),
                label: compact ? 'batidas' : 'número de batidas',
                icon: Icons.timer,
                color: const Color(0xFFF59E0B),
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
    return Semantics(
      label: '$label. $symbol igual a $value.',
      child: ExcludeSemantics(
        child: Container(
          constraints: BoxConstraints(
            minHeight: compact ? 76 : 82,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 16,
            vertical: compact ? 12 : 14,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: color.withValues(alpha: 0.55),
              width: 1.4,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool stackText = compact || constraints.maxWidth < 250;

              if (stackText) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _VariableExpression(
                            symbol: symbol,
                            value: value,
                            color: color,
                            compact: compact,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            label,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF0F172A),
                              fontSize: compact ? 12 : 13,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _VariableExpression(
                    symbol: symbol,
                    value: value,
                    color: color,
                    compact: compact,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _VariableExpression extends StatelessWidget {
  final String symbol;
  final String value;
  final Color color;
  final bool compact;

  const _VariableExpression({
    required this.symbol,
    required this.value,
    required this.color,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$symbol = $value',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: compact ? 19 : 22,
        fontWeight: FontWeight.w900,
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
  final double sortOrder;
  final bool showMathSymbols;
  final GlobalKey? symbolsKey;
  final ValueChanged<String> onChanged;

  const _AnswerField({
    super.key,
    required this.label,
    required this.value,
    required this.minLines,
    required this.maxLines,
    required this.keyboardType,
    required this.textInputAction,
    required this.semanticsHint,
    required this.sortOrder,
    required this.onChanged,
    this.showMathSymbols = false,
    this.symbolsKey,
  });

  @override
  State<_AnswerField> createState() => _AnswerFieldState();
}

class _AnswerFieldState extends State<_AnswerField> {
  static final stt.SpeechToText _sharedSpeech = stt.SpeechToText();
  static _AnswerFieldState? _activeListeningField;
  static bool _speechInitialized = false;
  static bool _speechAvailable = false;
  static bool _isChangingField = false;

  late final TextEditingController _controller;
  late final FlutterTts _tts;

  bool _isSpeaking = false;
  bool _isListening = false;
  bool _symbolsExpanded = false;

  static const List<_MathSymbolItem> _mathSymbols = [
    _MathSymbolItem(
      symbol: 'n',
      description:
          'Use n para representar a quantidade de notas escolhidas. Exemplo: se você escolheu 3 notas, então n = 3.',
    ),
    _MathSymbolItem(
      symbol: 'b',
      description:
          'Use b para representar a quantidade de batidas ou posições da música. Exemplo: se a música tem 2 batidas, então b = 2.',
    ),
    _MathSymbolItem(
      symbol: '×',
      description:
          'Use o sinal de multiplicação para contar possibilidades em sequência. Exemplo: 3 × 3 = 9.',
    ),
    _MathSymbolItem(
      symbol: '=',
      description:
          'Use o sinal de igual para mostrar o resultado de uma conta ou equivalência. Exemplo: 3 × 3 = 9.',
    ),
    _MathSymbolItem(
      symbol: '^',
      description:
          'Use potência quando houver repetição. Exemplo: n^b significa n elevado a b. Se n = 3 e b = 2, então 3^2 = 9.',
    ),
    _MathSymbolItem(
      symbol: '!',
      description: 'Use fatorial quando a ordem importa e não há repetição.',
    ),
    _MathSymbolItem(
      symbol: '(',
      description: 'Use abre parênteses para organizar uma expressão.',
    ),
    _MathSymbolItem(
      symbol: ')',
      description: 'Use fecha parênteses para encerrar uma parte da expressão.',
    ),
    _MathSymbolItem(
      symbol: '-',
      description:
          'Use subtração para indicar uma diferença. Exemplo: n - b representa a quantidade de notas menos a quantidade de batidas.',
    ),
    _MathSymbolItem(
      symbol: '/',
      description: 'Use divisão para representar uma fração.',
    ),
    _MathSymbolItem(
      symbol: '0',
      description: '',
      showInfo: false,
    ),
    _MathSymbolItem(
      symbol: '1',
      description: '',
      showInfo: false,
    ),
    _MathSymbolItem(
      symbol: '2',
      description: '',
      showInfo: false,
    ),
    _MathSymbolItem(
      symbol: '3',
      description: '',
      showInfo: false,
    ),
    _MathSymbolItem(
      symbol: '4',
      description: '',
      showInfo: false,
    ),
    _MathSymbolItem(
      symbol: '5',
      description: '',
      showInfo: false,
    ),
    _MathSymbolItem(
      symbol: '6',
      description: '',
      showInfo: false,
    ),
    _MathSymbolItem(
      symbol: '7',
      description: '',
      showInfo: false,
    ),
    _MathSymbolItem(
      symbol: '8',
      description: '',
      showInfo: false,
    ),
    _MathSymbolItem(
      symbol: '9',
      description: '',
      showInfo: false,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.value);

    _tts = FlutterTts();
    _configureTts();

    // IMPORTANTE:
    // Não inicialize o reconhecimento de voz aqui.
    // O speech_to_text pode solicitar a permissão do microfone durante
    // initialize(). Como os campos são construídos junto com a tela do
    // tutorial, isso faria a janela do sistema aparecer sobre a narração.
    //
    // A inicialização agora acontece somente quando a pessoa toca no
    // botão do microfone.
  }

  Future<void> _configureTts() async {
    await _tts.setLanguage('pt-BR');
    await _tts.setSpeechRate(0.48);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    await _tts.awaitSpeakCompletion(true);

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

  Future<bool> _showMicrophoneExplanation() async {
    if (!mounted) return false;

    final bool? shouldContinue = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final String permissionMessage = kIsWeb
            ? 'Para preencher esta resposta falando, o Batinotas precisa '
                'usar o microfone. Depois de tocar em Continuar, o navegador '
                'mostrará uma solicitação de permissão. Nessa solicitação, '
                'selecione Permitir.'
            : 'Para preencher esta resposta falando, o Batinotas precisa '
                'usar o microfone. Depois de tocar em Continuar, o celular '
                'mostrará uma solicitação de permissão. Nessa solicitação, '
                'permita o uso do microfone durante o uso do aplicativo.';

        return AlertDialog(
          semanticLabel: 'Explicação sobre a permissão do microfone',
          title: const Text('Usar o microfone'),
          content: Semantics(
            liveRegion: true,
            child: Text(permissionMessage),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Agora não'),
            ),
            FilledButton(
              autofocus: true,
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Continuar'),
            ),
          ],
        );
      },
    );

    return shouldContinue ?? false;
  }

  Future<void> _initSpeech() async {
    if (_speechInitialized) return;

    _speechInitialized = true;

    _speechAvailable = await _sharedSpeech.initialize(
      onStatus: (status) {
        final activeField = _activeListeningField;

        if (status == 'done' || status == 'notListening') {
          if (activeField != null && activeField.mounted) {
            activeField.setState(() {
              activeField._isListening = false;
            });
          }

          _activeListeningField = null;
        }
      },
      onError: (error) {
        final activeField = _activeListeningField;

        if (activeField != null && activeField.mounted) {
          activeField.setState(() {
            activeField._isListening = false;
          });

          ScaffoldMessenger.of(activeField.context).showSnackBar(
            SnackBar(
              content: Text(
                'Não foi possível reconhecer a fala: ${error.errorMsg}',
              ),
            ),
          );
        }

        _activeListeningField = null;
      },
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _stopCurrentListeningField() async {
    if (_activeListeningField == null) return;

    final oldField = _activeListeningField;

    await _sharedSpeech.stop();

    if (oldField != null && oldField.mounted) {
      oldField.setState(() {
        oldField._isListening = false;
      });
    }

    _activeListeningField = null;

    await Future<void>.delayed(const Duration(milliseconds: 350));
  }

  Future<void> _toggleListen() async {
    if (_isChangingField) return;

    _isChangingField = true;

    try {
      if (_isListening && _activeListeningField == this) {
        await _sharedSpeech.stop();

        _activeListeningField = null;

        if (mounted) {
          setState(() {
            _isListening = false;
          });
        }

        return;
      }

      if (_activeListeningField != null && _activeListeningField != this) {
        await _stopCurrentListeningField();
      }

      if (_isSpeaking) {
        await _tts.stop();

        if (mounted) {
          setState(() {
            _isSpeaking = false;
          });
        }
      }

      if (!_speechInitialized) {
        final shouldContinue = await _showMicrophoneExplanation();

        if (!shouldContinue) {
          return;
        }

        // É esta inicialização que pode abrir a janela oficial de permissão
        // do Android, iOS ou navegador. Agora ela só ocorre após uma ação
        // consciente da pessoa usuária.
        await _initSpeech();
      }

      if (!_speechAvailable) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Reconhecimento de voz não disponível neste dispositivo.',
              ),
            ),
          );
        }

        return;
      }

      _activeListeningField = this;

      if (mounted) {
        setState(() {
          _isListening = true;
        });
      }

      await _sharedSpeech.listen(
        onResult: (result) {
          if (_activeListeningField != this) return;

          final recognizedText = result.recognizedWords.trim();

          if (recognizedText.isEmpty) return;

          _controller.text = recognizedText;
          _controller.selection = TextSelection.collapsed(
            offset: _controller.text.length,
          );

          widget.onChanged(recognizedText);

          if (mounted) {
            setState(() {});
          }
        },
        listenOptions: stt.SpeechListenOptions(
          localeId: 'pt_BR',
          listenMode: stt.ListenMode.dictation,
          partialResults: true,
        ),
      );
    } finally {
      _isChangingField = false;
    }
  }

  void _openAllSymbolsInfo() {
    SemanticsService.announce(
      'Abrindo explicações dos símbolos matemáticos.',
      TextDirection.ltr,
    );

    final itemsWithInfo = _mathSymbols.where((item) {
      return item.description.trim().isNotEmpty;
    }).toList();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Color(0xFF2563EB),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text('Explicações dos símbolos'),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: itemsWithInfo.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Semantics(
                    container: true,
                    label: '${item.symbol}. ${item.description}',
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item.symbol,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.description,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                SemanticsService.announce(
                  'Explicações dos símbolos fechadas.',
                  TextDirection.ltr,
                );
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _insertSymbol(String symbol) {
    final text = _controller.text;
    final selection = _controller.selection;

    final int start = selection.isValid ? selection.start : text.length;
    final int end = selection.isValid ? selection.end : text.length;

    final newText = text.replaceRange(start, end, symbol);
    final newOffset = start + symbol.length;

    _controller.text = newText;
    _controller.selection = TextSelection.collapsed(offset: newOffset);

    widget.onChanged(newText);

    if (mounted) {
      setState(() {});
    }
  }

  void _deleteLastCharacter() {
    final text = _controller.text;
    final selection = _controller.selection;

    if (text.isEmpty) return;

    final int cursorPosition =
        selection.isValid ? selection.baseOffset : text.length;

    if (cursorPosition <= 0) return;

    final newText = text.replaceRange(
      cursorPosition - 1,
      cursorPosition,
      '',
    );

    final newOffset = cursorPosition - 1;

    _controller.text = newText;
    _controller.selection = TextSelection.collapsed(offset: newOffset);

    widget.onChanged(newText);

    if (mounted) {
      setState(() {});
    }

    SemanticsService.announce(
      'Último caractere apagado.',
      TextDirection.ltr,
    );
  }

  void _toggleSymbolsPanel() {
    if (!mounted) return;

    setState(() {
      _symbolsExpanded = !_symbolsExpanded;
    });

    SemanticsService.announce(
      _symbolsExpanded
          ? 'Painel de símbolos matemáticos aberto.'
          : 'Painel de símbolos matemáticos fechado.',
      TextDirection.ltr,
    );
  }

  Widget _buildToggleSymbolsButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Semantics(
        container: true,
        button: true,
        label: _symbolsExpanded
            ? 'Fechar símbolos matemáticos'
            : 'Abrir símbolos matemáticos',
        child: ExcludeSemantics(
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
            ),
            onPressed: _toggleSymbolsPanel,
            icon: Icon(
              _symbolsExpanded ? Icons.keyboard_arrow_up : Icons.functions,
            ),
            label: Text(
              _symbolsExpanded ? 'Fechar símbolos' : 'Símbolos',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInlineSymbolsPanel() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Toque em um símbolo para inserir na regra geral:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
              Semantics(
                container: true,
                button: true,
                sortKey: const OrdinalSortKey(2.10),
                label: 'Abrir explicações dos símbolos matemáticos',
                child: ExcludeSemantics(
                  child: IconButton(
                    tooltip: 'Explicações dos símbolos',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    iconSize: 22,
                    onPressed: _openAllSymbolsInfo,
                    icon: const Icon(
                      Icons.info_outline,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...List.generate(_mathSymbols.length, (index) {
                final item = _mathSymbols[index];

                return _SymbolButton(
                  item: item,
                  sortOrder: 2.20 + (index * 0.01),
                  onTap: () {
                    _insertSymbol(item.symbol);
                  },
                );
              }),
              _DeleteSymbolButton(
                onTap: _deleteLastCharacter,
              ),
            ],
          ),
        ],
      ),
    );
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
    final suffixButtons = <Widget>[
      Semantics(
        button: true,
        sortKey: OrdinalSortKey(widget.sortOrder + 0.05),
        label: _isListening
            ? 'Parar gravação da resposta por voz do campo ${widget.label}'
            : 'Falar resposta para preencher o campo ${widget.label}',
        child: IconButton(
          tooltip: _isListening ? 'Parar gravação' : 'Falar resposta',
          onPressed: _toggleListen,
          icon: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            color: _isListening
                ? const Color(0xFFDC2626)
                : const Color(0xFF2563EB),
          ),
        ),
      ),
    ];

    return Semantics(
      sortKey: OrdinalSortKey(widget.sortOrder),
      explicitChildNodes: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool compact = constraints.maxWidth < 360;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                maxLines: compact ? 3 : 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  fontSize: compact ? 14 : 16,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _controller,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                // Desabilita o teclado somente no campo da regra geral
                readOnly: widget.showMathSymbols,

                // Mantém o cursor visível para mostrar onde o símbolo será inserido
                showCursor: true,

                keyboardType: widget.showMathSymbols
                    ? TextInputType.none
                    : widget.keyboardType,

                textInputAction: widget.textInputAction,
                onChanged: widget.onChanged,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: '',
                  semanticCounterText: widget.semanticsHint,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: suffixButtons,
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
              if (widget.showMathSymbols) ...[
                KeyedSubtree(
                  key: widget.symbolsKey,
                  child: _buildToggleSymbolsButton(),
                ),
                if (_symbolsExpanded) _buildInlineSymbolsPanel(),
              ],
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_activeListeningField == this) {
      _activeListeningField = null;
      _sharedSpeech.stop();
    }

    _tts.stop();
    _controller.dispose();

    super.dispose();
  }
}

class _MathSymbolItem {
  final String symbol;
  final String description;
  final bool showInfo;

  const _MathSymbolItem({
    required this.symbol,
    required this.description,
    this.showInfo = true,
  });
}

class _SymbolButton extends StatelessWidget {
  final _MathSymbolItem item;
  final VoidCallback onTap;
  final double sortOrder;

  const _SymbolButton({
    required this.item,
    required this.onTap,
    required this.sortOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      sortKey: OrdinalSortKey(sortOrder),
      label: 'Inserir símbolo ${item.symbol}',
      hint: item.description.isEmpty ? null : item.description,
      child: ExcludeSemantics(
        child: SizedBox(
          width: 42,
          height: 36,
          child: FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              item.symbol,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteSymbolButton extends StatelessWidget {
  final VoidCallback onTap;

  const _DeleteSymbolButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      sortKey: const OrdinalSortKey(2.90),
      label: 'Apagar último caractere da regra geral',
      child: ExcludeSemantics(
        child: SizedBox(
          width: 46,
          height: 36,
          child: FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Icon(
              Icons.backspace_outlined,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
