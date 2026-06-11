import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/combinatorics_controller.dart';
import '../../models/combination_mode.dart';

class FormationModeSelector extends StatelessWidget {
  const FormationModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CombinatoricsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final bool isVerySmall = constraints.maxWidth < 420;

            return Row(
              children: [
                Expanded(
                  child: _FormationModeButton(
                    selected: controller.mode == CombinationMode.withRepetition,
                    title: isVerySmall ? 'Com\nrepetição' : 'Com repetição',
                    icon: Icons.repeat,
                    selectedColor: const Color(0xFF2563EB),
                    compact: isVerySmall,
                    onTap: () {
                      controller.setMode(CombinationMode.withRepetition);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _FormationModeButton(
                    selected:
                        controller.mode == CombinationMode.withoutRepetition,
                    title: isVerySmall ? 'Sem\nrepetição' : 'Sem repetição',
                    icon: Icons.block,
                    selectedColor: const Color(0xFF0F766E),
                    compact: isVerySmall,
                    onTap: () {
                      controller.setMode(CombinationMode.withoutRepetition);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FormationModeButton extends StatelessWidget {
  final bool selected;
  final String title;
  final IconData icon;
  final Color selectedColor;
  final bool compact;
  final VoidCallback onTap;

  const _FormationModeButton({
    required this.selected,
    required this.title,
    required this.icon,
    required this.selectedColor,
    required this.compact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        selected ? selectedColor : selectedColor.withValues(alpha: 0.13);

    final foregroundColor = selected ? Colors.white : const Color(0xFF0F172A);
    final borderColor = selected ? Colors.black87 : selectedColor;

    return Semantics(
      button: true,
      selected: selected,
      label: '$title. ${selected ? 'Selecionado' : 'Não selecionado'}',
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: compact ? 56 : 60,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 6 : 10,
            vertical: compact ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: selected ? 2.2 : 1.2,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: selectedColor.withValues(alpha: 0.22),
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                width: compact ? 28 : 32,
                height: compact ? 28 : 32,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.22)
                      : selectedColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: selected ? Colors.white : selectedColor,
                  size: compact ? 18 : 20,
                ),
              ),
              SizedBox(width: compact ? 5 : 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: compact ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: compact ? 12 : 14,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
              ),
              if (selected && !compact) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
