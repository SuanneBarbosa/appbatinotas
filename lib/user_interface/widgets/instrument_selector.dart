import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/combinatorics_controller.dart';
import '../../models/instrument.dart';

class InstrumentSelector extends StatelessWidget {
  const InstrumentSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CombinatoricsController>();

    return DropdownButtonFormField<Instrument>(
      value: controller.selectedInstrument,
      isExpanded: true,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18,
          ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(
          Icons.music_note,
          size: 30,
        ),
        label: Text(
          'Escolha o instrumento',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 22,
              ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 22,
        ),
      ),
      items: availableInstruments.map((instrument) {
        return DropdownMenuItem(
          value: instrument,
          child: Text(
            instrument.displayName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }).toList(),
      onChanged: (instrument) {
        if (instrument != null) {
          controller.setInstrument(instrument);
        }
      },
    );
  }
}
