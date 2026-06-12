import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../models/combination_mode.dart';
import '../models/instrument.dart';
import '../models/music_note.dart';
import '../models/saved_activity_model.dart';
import '../services/note_audio_service.dart';
import '../services/saved_activity_service.dart';
import '../utils/combinatorics_math.dart';

enum ExamplesVisualizationMode { colorWithNumber, iconWithColor, nameWithColor }

class CombinatoricsController extends ChangeNotifier {
  final NoteAudioService audioService;

  CombinatoricsController({required this.audioService}) {
    _selectedNotes.addAll(defaultNotes.take(3));
    refreshExamples();
  }

  static const int maxListAll = 64;
  static const int exampleCount = 64;

  final List<MusicNote> availableNotes = defaultNotes;
  final List<MusicNote> _selectedNotes = [];
  final List<List<MusicNote>> _examples = [];

  CombinationMode _mode = CombinationMode.withRepetition;
  int _beatCount = 3;
  int? _playingExampleIndex;
  int? _playingNoteIndex;
  ExamplesVisualizationMode _visualizationMode =
      ExamplesVisualizationMode.colorWithNumber;

  String _studentFoundTotal = '';
  String _studentCalculation = '';
  String _studentGeneralRule = '';
  String _studentExplanation = '';

  List<MusicNote> get selectedNotes => List.unmodifiable(_selectedNotes);
  List<List<MusicNote>> get examples => List.unmodifiable(_examples);

  CombinationMode get mode => _mode;
  int get beatCount => _beatCount;
  int get n => _selectedNotes.length;

  int? get playingExampleIndex => _playingExampleIndex;
  int? get playingNoteIndex => _playingNoteIndex;
  ExamplesVisualizationMode get visualizationMode => _visualizationMode;

  String get studentFoundTotal => _studentFoundTotal;
  String get studentCalculation => _studentCalculation;
  String get studentGeneralRule => _studentGeneralRule;
  String get studentExplanation => _studentExplanation;

  Instrument get selectedInstrument => audioService.selectedInstrument;

  bool get canCalculateFixedWithoutRepetition => n > 0 && _beatCount <= n;

  bool get isImpossibleWithoutRepetition =>
      n > 0 && _mode == CombinationMode.withoutRepetition && _beatCount > n;

  BigInt? get totalWithRepetition {
    if (n == 0) return null;
    return CombinatoricsMath.powInt(n, _beatCount);
  }

  BigInt? get totalWithoutRepetition {
    if (n == 0) return null;
    return CombinatoricsMath.arrangementsWithoutRepetition(n, _beatCount);
  }

  BigInt? get activeTotal {
    if (n == 0) return null;

    switch (_mode) {
      case CombinationMode.withRepetition:
        return totalWithRepetition;
      case CombinationMode.withoutRepetition:
        return totalWithoutRepetition;
    }
  }

  bool get shouldListAll {
    final total = activeTotal;
    return total != null && total <= BigInt.from(maxListAll);
  }

  void toggleNote(MusicNote note) {
    final exists = _selectedNotes.any((item) => item.id == note.id);

    if (exists) {
      _selectedNotes.removeWhere((item) => item.id == note.id);
    } else {
      _selectedNotes.add(note);
      _selectedNotes.sort((a, b) => a.id.compareTo(b.id));
    }

    _announce('Quantidade de notas escolhidas: $n. Portanto, n igual a $n.');
    refreshExamples();
    notifyListeners();
  }

  void selectAllNotes() {
    _selectedNotes
      ..clear()
      ..addAll(availableNotes);

    refreshExamples();
    notifyListeners();
  }

  void clearNotes() {
    _selectedNotes.clear();
    refreshExamples();
    notifyListeners();
  }

  void setMode(CombinationMode mode) {
    _mode = mode;
    refreshExamples();
    notifyListeners();
  }

  void setBeatCount(int value) {
    _beatCount = value.clamp(1, 12);
    refreshExamples();
    notifyListeners();
  }

  void setVisualizationMode(ExamplesVisualizationMode mode) {
    _visualizationMode = mode;
    notifyListeners();
  }

  void setInstrument(Instrument instrument) {
    audioService.selectedInstrument = instrument;
    notifyListeners();
  }

  void setStudentFoundTotal(String value) {
    _studentFoundTotal = value;
    notifyListeners();
  }

  void setStudentCalculation(String value) {
    _studentCalculation = value;
    notifyListeners();
  }

  void setStudentGeneralRule(String value) {
    _studentGeneralRule = value;
    notifyListeners();
  }

  void setStudentExplanation(String value) {
    _studentExplanation = value;
    notifyListeners();
  }

  void refreshExamples() {
    _examples
      ..clear()
      ..addAll(_generateExamples());
  }

  List<List<MusicNote>> _generateExamples() {
    if (n == 0) return [];

    final length = _beatCount;

    if (_mode == CombinationMode.withoutRepetition && length > n) {
      return [];
    }

    if (shouldListAll) {
      return _generateAll(length);
    }

    return _generateSample(length, exampleCount);
  }

  List<List<MusicNote>> _generateAll(int length) {
    switch (_mode) {
      case CombinationMode.withRepetition:
        return _generateWithRepetition(length);
      case CombinationMode.withoutRepetition:
        return _generateWithoutRepetition(length);
    }
  }

  List<List<MusicNote>> _generateWithRepetition(int length) {
    final result = <List<MusicNote>>[];

    void generate(List<MusicNote> current) {
      if (current.length == length) {
        result.add(List<MusicNote>.from(current));
        return;
      }

      for (final note in _selectedNotes) {
        current.add(note);
        generate(current);
        current.removeLast();
      }
    }

    generate([]);
    return result;
  }

  List<List<MusicNote>> _generateWithoutRepetition(int length) {
    final result = <List<MusicNote>>[];

    void generate(List<MusicNote> current, List<MusicNote> remaining) {
      if (current.length == length) {
        result.add(List<MusicNote>.from(current));
        return;
      }

      for (int i = 0; i < remaining.length; i++) {
        final note = remaining[i];

        current.add(note);

        final next = List<MusicNote>.from(remaining)..removeAt(i);

        generate(current, next);

        current.removeLast();
      }
    }

    generate([], List<MusicNote>.from(_selectedNotes));
    return result;
  }

  List<List<MusicNote>> _generateSample(int length, int count) {
    final random = Random(12 + n + length);
    final seen = <String>{};
    final result = <List<MusicNote>>[];

    int guard = 0;

    while (result.length < count && guard < 1000) {
      guard++;

      final pool = List<MusicNote>.from(_selectedNotes);
      final melody = <MusicNote>[];

      for (int i = 0; i < length; i++) {
        if (pool.isEmpty) break;

        final index = random.nextInt(pool.length);

        melody.add(pool[index]);

        if (_mode == CombinationMode.withoutRepetition) {
          pool.removeAt(index);
        }
      }

      if (melody.length == length) {
        final key = melody.map((note) => note.id).join('-');

        if (seen.add(key)) {
          result.add(melody);
        }
      }
    }

    return result;
  }

  Future<void> playExample(int index) async {
    if (index < 0 || index >= _examples.length) return;

    _playingExampleIndex = index;
    notifyListeners();

    await audioService.playMelody(
      _examples[index],
      onNote: (noteIndex) {
        _playingNoteIndex = noteIndex >= 0 ? noteIndex : null;
        notifyListeners();
      },
    );

    _playingExampleIndex = null;
    _playingNoteIndex = null;
    notifyListeners();
  }

  Future<void> playSelectedNote(MusicNote note) async {
    await audioService.playNote(note);
  }

  String fixedRuleWithRepetition() => '$n^$_beatCount';

  String fixedExpandedWithRepetition() {
    if (n == 0) return '';
    return List.filled(_beatCount, '$n').join(' × ');
  }

  String fixedExpandedWithoutRepetition() {
    if (n == 0) return '';

    if (_beatCount > n) {
      return 'impossível, pois b > n';
    }

    return List.generate(_beatCount, (i) => '${n - i}').join(' × ');
  }

  String generalRuleWithRepetition() => 'M(n, b) = n^b';

  String generalRuleWithoutRepetition() => 'M(n, b) = n! / (n - b)!';

  String expectedTotalText() {
    if (n == 0) {
      return 'Escolha as notas para calcular.';
    }

    if (_mode == CombinationMode.withRepetition) {
      final total = totalWithRepetition ?? BigInt.zero;
      return CombinatoricsMath.formatBigInt(total);
    }

    if (_beatCount > n) {
      return 'Não é possível sem repetição, pois b > n.';
    }

    final total = totalWithoutRepetition ?? BigInt.zero;
    return CombinatoricsMath.formatBigInt(total);
  }

  String expectedCalculationText() {
    if (n == 0) {
      return 'Escolha as notas primeiro.';
    }

    if (_mode == CombinationMode.withRepetition) {
      final total = totalWithRepetition ?? BigInt.zero;
      return '${fixedExpandedWithRepetition()} = ${CombinatoricsMath.formatBigInt(total)}';
    }

    if (_beatCount > n) {
      return 'Não é possível, pois a quantidade de batidas é maior que a quantidade de notas.';
    }

    final total = totalWithoutRepetition ?? BigInt.zero;
    return '${fixedExpandedWithoutRepetition()} = ${CombinatoricsMath.formatBigInt(total)}';
  }

  String expectedGeneralRuleText() {
    if (_mode == CombinationMode.withRepetition) {
      return generalRuleWithRepetition();
    }

    return generalRuleWithoutRepetition();
  }

  Future<void> saveCurrentActivity() async {
    final activity = SavedActivityModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      selectedNoteIds: _selectedNotes.map((note) => note.id).toList(),
      selectedNotes: _selectedNotes.map((note) => note.solfege).toList(),
      noteCount: n,
      beatCount: _beatCount,
      mode: _mode.label,
      instrumentId: selectedInstrument.id,
      instrument: selectedInstrument.displayName,

      // Mantido vazio para não salvar sugestão/gabarito.
      expectedTotal: '',
      expectedCalculation: '',
      expectedGeneralRule: '',

      studentFoundTotal: _studentFoundTotal,
      studentCalculation: _studentCalculation,
      studentGeneralRule: _studentGeneralRule,
      studentExplanation: _studentExplanation,
    );

    await SavedActivityService.saveActivity(activity);
  }

  void applySavedActivity(SavedActivityModel activity) {
    _selectedNotes
      ..clear()
      ..addAll(
        availableNotes.where(
          (note) => activity.selectedNoteIds.contains(note.id),
        ),
      );

    _selectedNotes.sort((a, b) => a.id.compareTo(b.id));

    _beatCount = activity.beatCount.clamp(1, 12);

    if (activity.mode == CombinationMode.withoutRepetition.label) {
      _mode = CombinationMode.withoutRepetition;
    } else {
      _mode = CombinationMode.withRepetition;
    }

    final matchingInstrument = availableInstruments.where(
      (instrument) => instrument.id == activity.instrumentId,
    );

    if (matchingInstrument.isNotEmpty) {
      audioService.selectedInstrument = matchingInstrument.first;
    }

    _studentFoundTotal = activity.studentFoundTotal;
    _studentCalculation = activity.studentCalculation;
    _studentGeneralRule = activity.studentGeneralRule;
    _studentExplanation = activity.studentExplanation;

    refreshExamples();
    notifyListeners();
  }

  String finalReport() {
    final buffer = StringBuffer();

    buffer.writeln('Relatório da atividade - CombinaSom Algébrico');
    buffer.writeln(
      'Notas escolhidas: ${_selectedNotes.map((note) => note.solfege).join(', ')}',
    );
    buffer.writeln('Quantidade de notas: n = $n');
    buffer.writeln('Modo: ${_mode.label}');
    buffer.writeln('Batidas: $_beatCount');
    buffer.writeln('Instrumento: ${selectedInstrument.displayName}');
    buffer.writeln('');

    if (_mode == CombinationMode.withRepetition) {
      final total = totalWithRepetition ?? BigInt.zero;

      buffer.writeln(
        'Cálculo: ${fixedExpandedWithRepetition()} = ${CombinatoricsMath.formatBigInt(total)}',
      );
      buffer.writeln('Potência: ${fixedRuleWithRepetition()}');
      buffer.writeln('Regra geral: ${generalRuleWithRepetition()}');
    } else {
      final total = totalWithoutRepetition ?? BigInt.zero;

      buffer.writeln(
        'Cálculo: ${fixedExpandedWithoutRepetition()} = ${CombinatoricsMath.formatBigInt(total)}',
      );
      buffer.writeln('Regra geral: ${generalRuleWithoutRepetition()}');
    }

    buffer.writeln('');
    buffer.writeln('Respostas do aluno:');

    buffer.writeln('1. Quantas músicas você formou/encontrou?');
    buffer.writeln(
      _studentFoundTotal.trim().isEmpty
          ? '(não preenchida)'
          : _studentFoundTotal.trim(),
    );

    buffer.writeln('');
    buffer.writeln('2. Qual cálculo você utilizou para encontrar esse valor?');
    buffer.writeln(
      _studentCalculation.trim().isEmpty
          ? '(não preenchida)'
          : _studentCalculation.trim(),
    );

    buffer.writeln('');
    buffer.writeln(
      '3. Escreva a regra geral que representa esse tipo de situação.',
    );
    buffer.writeln(
      _studentGeneralRule.trim().isEmpty
          ? '(não preenchida)'
          : _studentGeneralRule.trim(),
    );

    buffer.writeln('');
    buffer.writeln('4. Explique com suas palavras como essa regra funciona.');
    buffer.writeln(
      _studentExplanation.trim().isEmpty
          ? '(não preenchida)'
          : _studentExplanation.trim(),
    );

    return buffer.toString();
  }

  void _announce(String message) {
    // ignore: deprecated_member_use
    SemanticsService.announce(message, TextDirection.ltr);
  }
}
