import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/combinatorics_controller.dart';
import '../../models/saved_activity_model.dart';
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

  String _formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} '
        '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
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
                      IconButton(
                        tooltip: 'Aplicar na tela',
                        icon: const Icon(Icons.open_in_new),
                        onPressed: () => _applyActivity(activity),
                      ),
                      IconButton(
                        tooltip: 'Excluir atividade',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteActivity(activity.id),
                      ),
                    ],
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _applyActivity(activity),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Aplicar na tela'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoLine(
                      label: 'Notas escolhidas',
                      value: activity.selectedNotes.join(', '),
                    ),
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
                    _InfoLine(
                      label: 'Instrumento',
                      value: activity.instrument,
                    ),
                    const Divider(),
                    _InfoLine(
                      label: 'Resposta 1: músicas encontradas',
                      value: activity.studentFoundTotal.isEmpty
                          ? '(não preenchida)'
                          : activity.studentFoundTotal,
                    ),
                    _InfoLine(
                      label: 'Resposta 2: cálculo utilizado',
                      value: activity.studentCalculation.isEmpty
                          ? '(não preenchida)'
                          : activity.studentCalculation,
                    ),
                    _InfoLine(
                      label: 'Resposta 3: regra geral',
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
