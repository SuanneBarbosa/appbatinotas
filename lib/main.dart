import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'controllers/combinatorics_controller.dart';
import 'services/combinatorics_tutorial_service.dart';
import 'services/note_audio_service.dart';
import 'services/orientation_service.dart';
import 'user_interface/screens/home_tutorial_overlay.dart';
import 'user_interface/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isMobilePlatform() {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  bool orientationShown = true;

  if (isMobilePlatform()) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final orientationService = OrientationService();
    orientationShown = await orientationService.hasShownOrientation();
  }

  runApp(
    CombinaSomAlgebricoApp(
      orientationShown: orientationShown,
    ),
  );
}

class CombinaSomAlgebricoApp extends StatelessWidget {
  final bool orientationShown;

  const CombinaSomAlgebricoApp({
    super.key,
    required this.orientationShown,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => NoteAudioService()),
        ChangeNotifierProxyProvider<NoteAudioService, CombinatoricsController>(
          create: (context) => CombinatoricsController(
            audioService: context.read<NoteAudioService>(),
          ),
          update: (_, audioService, previous) =>
              previous ?? CombinatoricsController(audioService: audioService),
        ),
        ChangeNotifierProvider(
          create: (_) => CombinatoricsTutorialController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Batinotas',
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
          cardTheme: CardThemeData(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        home: kIsWeb
            ? const HomeTutorialOverlay()
            : SplashScreen(
                orientationShown: orientationShown,
              ),
      ),
    );
  }
}
