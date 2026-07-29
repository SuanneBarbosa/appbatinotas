import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/combinatorics_math.dart';
import '../../controllers/combinatorics_controller.dart';
import '../../models/saved_activity_model.dart';
import 'package:flutter/services.dart';
import '../../services/saved_activity_service.dart';

class SavedActivitiesScreen extends StatefulWidget {
  const SavedActivitiesScreen({super.key});

  @override
  State<SavedActivitiesScreen> createState() => _SavedActivitiesScreenState();
}

class _SavedActivitiesScreenState extends State<SavedActivitiesScreen> {
  late Future<List<SavedActivityModel>> _futureActivities;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  void _loadActivities() {
    _futureActivities = SavedActivityService.getActivities();
  }

  Future<void> _deleteActivity(String id) async {
    await SavedActivityService.deleteActivity(id);

    setState(() {
      _loadActivities();
    });
  }

  void _applyActivity(SavedActivityModel activity) {
    context.read<CombinatoricsController>().applySavedActivity(activity);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Atividade aplicada na tela!'),
      ),
    );

    Navigator.pop(context);
  }

  void _copyAnswers(SavedActivityModel activity) {
    final buffer = StringBuffer();
    buffer.writeln('Quantas músicas você encontrou?');
    buffer.writeln(activity.studentFoundTotal.isEmpty
        ? '(não preenchida)'
        : activity.studentFoundTotal);
    buffer.writeln();
    buffer.writeln('Escreva a regra geral.');
    buffer.writeln(activity.studentGeneralRule.isEmpty
        ? '(não preenchida)'
        : activity.studentGeneralRule);
    if (activity.studentExplanation.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Explicação:');
      buffer.writeln(activity.studentExplanation);
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Respostas copiadas!'),
      ),
    );
  }

  String _formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} '
        '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }

  String _onlyNumbers(String value) {
    final matches = RegExp(r'\d+').allMatches(value);

    return matches.map((match) => match.group(0)).join();
  }

  BigInt? _expectedTotalForActivity(SavedActivityModel activity) {
    final int n = activity.noteCount;
    final int b = activity.beatCount;

    if (n <= 0 || b <= 0) {
      return null;
    }

    if (activity.mode == 'Com repetição') {
      return CombinatoricsMath.powInt(n, b);
    }

    if (activity.mode == 'Sem repetição') {
      if (b > n) {
        return BigInt.zero;
      }

      return CombinatoricsMath.arrangementsWithoutRepetition(n, b);
    }

    return null;
  }

  bool? _isStudentTotalCorrect(SavedActivityModel activity) {
    final expectedTotal = _expectedTotalForActivity(activity);

    if (expectedTotal == null) {
      return null;
    }

    final typedNumbers = _onlyNumbers(activity.studentFoundTotal);

    if (typedNumbers.isEmpty) {
      return null;
    }

    final studentTotal = BigInt.tryParse(typedNumbers);

    if (studentTotal == null) {
      return null;
    }

    return studentTotal == expectedTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeria de atividades'),
      ),
      body: FutureBuilder<List<SavedActivityModel>>(
        future: _futureActivities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final activities = snapshot.data ?? [];

          if (activities.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma atividade salva ainda.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    '${activity.mode} - ${activity.noteCount} notas e ${activity.beatCount} batidas',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  subtitle: Text(
                    '${activity.instrument} • ${_formatDate(activity.createdAt)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Semantics(
                        label: 'Aplicar esta atividade na tela principal',
                        child: IconButton(
                          tooltip: 'Aplicar na tela',
                          icon: const Icon(Icons.open_in_new),
                          onPressed: () => _applyActivity(activity),
                        ),
                      ),
                      Semantics(
                        label: 'Copiar as respostas desta atividade',
                        child: IconButton(
                          tooltip: 'Copiar respostas',
                          icon: const Icon(Icons.copy),
                          onPressed: () => _copyAnswers(activity),
                        ),
                      ),
                      Semantics(
                        label: 'Excluir esta atividade da galeria',
                        child: IconButton(
                          tooltip: 'Excluir atividade',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _deleteActivity(activity.id),
                        ),
                      ),
                    ],
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    _InfoLine(
                      label: 'Quantidade de notas',
                      value: 'n = ${activity.noteCount}',
                    ),
                    _InfoLine(
                      label: 'Número de batidas',
                      value: 'b = ${activity.beatCount}',
                    ),
                    _InfoLine(
                      label: 'Tipo de formação',
                      value: activity.mode,
                    ),
                    const Divider(),
                    _InfoLineWithStatus(
                      label: 'Músicas encontradas',
                      value: activity.studentFoundTotal.isEmpty
                          ? '(não preenchida)'
                          : activity.studentFoundTotal,
                      isCorrect: _isStudentTotalCorrect(activity),
                    ),
                    _InfoLine(
                      label: 'Regra geral',
                      value: activity.studentGeneralRule.isEmpty
                          ? '(não preenchida)'
                          : activity.studentGeneralRule,
                    ),
                    if (activity.studentExplanation.isNotEmpty)
                      _InfoLine(
                        label: 'Explicação',
                        value: activity.studentExplanation,
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(value),
          ),
        ],
      ),
    );
  }
}

class _AnswerStatusText extends StatelessWidget {
  final bool? isCorrect;

  const _AnswerStatusText({
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    if (isCorrect == null) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.help_outline,
            size: 18,
            color: Color(0xFF64748B),
          ),
          SizedBox(width: 4),
          Text(
            'Resposta não conferida',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      );
    }

    if (isCorrect == true) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: Color(0xFF16A34A),
          ),
          SizedBox(width: 4),
          Text(
            'Resposta correta',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF16A34A),
            ),
          ),
        ],
      );
    }

    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.cancel,
          size: 18,
          color: Color(0xFFDC2626),
        ),
        SizedBox(width: 4),
        Text(
          'Resposta incorreta',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFFDC2626),
          ),
        ),
      ],
    );
  }
}

class _InfoLineWithStatus extends StatelessWidget {
  final String label;
  final String value;
  final bool? isCorrect;

  const _InfoLineWithStatus({
    required this.label,
    required this.value,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 10,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SelectableText(value),
                _AnswerStatusText(
                  isCorrect: isCorrect,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
