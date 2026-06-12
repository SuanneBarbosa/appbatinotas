import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/combinatorics_controller.dart';
import '../../models/instrument.dart';
import '../screens/instructions_screen.dart';
import '../screens/thanks_screen.dart';
import '../screens/saved_activities_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CombinatoricsController>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Apoio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.20),
                              blurRadius: 8,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/IFSP_Logo.png',
                              height: 58,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 8),
                            Image.asset(
                              'assets/images/CNPQ_Logo.png',
                              height: 58,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 8),
                            Image.asset(
                              'assets/images/RUMO_Logo.png',
                              height: 58,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    tooltip: 'Fechar menu',
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text(
              'Instrumento',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: DropdownButtonFormField<Instrument>(
                initialValue: controller.selectedInstrument,
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                items: availableInstruments.map((instrument) {
                  return DropdownMenuItem(
                    value: instrument,
                    child: Text(instrument.displayName),
                  );
                }).toList(),
                onChanged: (instrument) {
                  if (instrument != null) {
                    controller.setInstrument(instrument);
                  }
                },
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text(
              'Visualização dos exemplos',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Semantics(
                label: 'Escolher forma de visualização dos exemplos',
                child: DropdownButtonFormField<ExamplesVisualizationMode>(
                  initialValue: controller.visualizationMode,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: ExamplesVisualizationMode.colorWithNumber,
                      child: Text('Cor com número'),
                    ),
                    DropdownMenuItem(
                      value: ExamplesVisualizationMode.iconWithColor,
                      child: Text('Ícone com cor'),
                    ),
                    DropdownMenuItem(
                      value: ExamplesVisualizationMode.nameWithColor,
                      child: Text('Nome com cor'),
                    ),
                  ],
                  onChanged: (mode) {
                    if (mode != null) {
                      controller.setVisualizationMode(mode);
                    }
                  },
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.collections_bookmark),
            title: const Text('Galeria de atividades'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SavedActivitiesScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Instruções de uso'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const UsageInstructionsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.handshake),
            title: const Text('Agradecimentos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ThankYouScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
