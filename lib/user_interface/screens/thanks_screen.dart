import 'package:flutter/material.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agradecimentos'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Column(
              children: [
                const Text(
                  'Apoio',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/IFSP_Logo.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    Image.asset(
                      'assets/images/CNPQ_Logo.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    Image.asset(
                      'assets/images/RUMO_Logo.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
