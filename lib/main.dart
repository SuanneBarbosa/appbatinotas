import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'controllers/combinatorics_controller.dart';
import 'services/note_audio_service.dart';
import 'user_interface/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const CombinaSomAlgebricoApp());
}

class CombinaSomAlgebricoApp extends StatelessWidget {
  const CombinaSomAlgebricoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => NoteAudioService()),
        ChangeNotifierProxyProvider<NoteAudioService, CombinatoricsController>(
          create: (context) => CombinatoricsController(
            audioService: context.read<NoteAudioService>(),
          ),
          update: (_, audioService, previous) => previous ?? CombinatoricsController(audioService: audioService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CombinaSom Algébrico',
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4F46E5),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          cardTheme: CardTheme(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
