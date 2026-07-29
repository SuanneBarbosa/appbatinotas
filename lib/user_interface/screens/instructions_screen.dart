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
            title: '1. Usar o menu lateral',
            description:
                'Toque no ícone de menu, no canto superior esquerdo da tela, para abrir o menu lateral. Nele você pode acessar as instruções, a galeria de atividades salvas, informações sobre o aplicativo e outras opções disponíveis.',
          ),
          _InstructionItem(
            title: '2. Escolher notas musicais',
            description:
                'Selecione as notas disponíveis. As notas escolhidas aparecem separadas na área de notas escolhidas. A quantidade de notas escolhidas representa o valor de n.',
          ),
          _InstructionItem(
            title: '3. Escolher o tipo de formação',
            description:
                'Defina se as músicas serão formadas com repetição ou sem repetição de notas. Com repetição, uma nota pode aparecer mais de uma vez. Sem repetição, cada nota pode aparecer apenas uma vez na mesma música.',
          ),
          _InstructionItem(
            title: '4. Escolher número de batidas',
            description:
                'Escolha quantas posições, ou batidas, cada combinação terá. A quantidade de batidas representa o valor de b.',
          ),
          _InstructionItem(
            title: '5. Observar Combinações',
            description:
                'O aplicativo mostra as combinações possíveis. Toque no botão de reprodução para ouvir cada combinação.',
          ),
          _InstructionItem(
            title: '6. Responder às perguntas',
            description:
                'Na seção de resultados, responda às perguntas para explicar quantas músicas foram encontradas e qual regra geral representa a situação.',
          ),
          _InstructionItem(
            title: '7. Usar o botão Símbolos',
            description:
                'Toque no botão Símbolos para abrir opções de símbolos matemáticos, como n, b, multiplicação, igualdade, potência e fatorial. Esses símbolos ajudam a escrever a regra geral.',
          ),
          _InstructionItem(
            title: '8. Usar o botão Limpar',
            description:
                'Toque no botão Limpar para apagar as respostas preenchidas nos campos da seção de resultados. Essa ação não apaga as notas escolhidas, as batidas ou os exemplos, apenas limpa os textos das respostas.',
          ),
          _InstructionItem(
            title: '9. Usar o botão Salvar',
            description:
                'Toque no botão Salvar para guardar a atividade atual na galeria. Serão salvas as notas escolhidas, o número de batidas, o tipo de formação, o instrumento e as respostas preenchidas.',
          ),
          _InstructionItem(
            title: '10. Consultar respostas na galeria',
            description:
                'No menu lateral, abra a galeria para consultar, copiar, aplicar na tela ou excluir atividades salvas anteriormente.',
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
