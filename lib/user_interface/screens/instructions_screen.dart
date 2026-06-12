import 'package:flutter/material.dart';

class UsageInstructionsScreen extends StatelessWidget {
  const UsageInstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instruções de uso'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _InstructionItem(
            title: '1. Escolher notas musicais',
            description:
                'Selecione as notas disponíveis. As notas escolhidas aparecem separadas na área de notas escolhidas.',
          ),
          _InstructionItem(
            title: '2. Escolher número de batidas',
            description:
                'Escolha quantas posições, ou batidas, cada música terá.',
          ),
          _InstructionItem(
            title: '3. Escolher o tipo de formação',
            description:
                'Defina se as músicas serão formadas com repetição ou sem repetição de notas.',
          ),
          _InstructionItem(
            title: '4. Observar exemplos sonoros',
            description:
                'O aplicativo mostra exemplos de músicas possíveis. Toque no botão de reprodução para ouvir cada exemplo.',
          ),
          _InstructionItem(
            title: '5. Responder às perguntas',
            description:
                'Na seção de resultados, responda às perguntas para explicar quantas músicas foram encontradas, qual cálculo foi usado e qual regra geral representa a situação.',
          ),
          _InstructionItem(
            title: '6. Salvar a atividade',
            description:
                'Toque no botão para salvar a atividade atual e suas respostas.',
          ),
          _InstructionItem(
            title: '7. Consultar respostas na galeria',
            description:
                'No menu lateral, abra a galeria para consultar, copiar, aplicar na tela ou excluir atividades salvas.',
          ),
        ],
      ),
    );
  }
}

class _InstructionItem extends StatelessWidget {
  final String title;
  final String description;

  const _InstructionItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.35,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
