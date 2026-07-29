import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/combinatorics_controller.dart';
import '../../services/combinatorics_tutorial_service.dart';
import '../widgets/hole_clipper.dart';
import '../widgets/vlibras_widget.dart';
import 'home_screen.dart';

class HomeTutorialOverlay extends StatefulWidget {
  const HomeTutorialOverlay({super.key});

  @override
  State<HomeTutorialOverlay> createState() => _HomeTutorialOverlayState();
}

class _HomeTutorialOverlayState extends State<HomeTutorialOverlay> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tutorial = context.read<CombinatoricsTutorialController>();

      final combinatorics = context.read<CombinatoricsController>();

      await tutorial.start(context);

      if (!mounted) return;

      if (tutorial.isTutorialActive) {
        // Durante o tutorial, apresenta um exemplo pronto.
        combinatorics.prepareTutorialExample();
      } else {
        // Caso o tutorial já tenha sido visto, inicia vazio.
        combinatorics.resetAfterTutorial();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tutorial = context.watch<CombinatoricsTutorialController>();

    final homeScreen = HomeScreen(
      menuKey: tutorial.menuKey,
      notesKey: tutorial.notesKey,
      modeKey: tutorial.modeKey,
      beatKey: tutorial.beatKey,
      examplesKey: tutorial.examplesKey,
      resultKey: tutorial.resultKey,
      symbolsKey: tutorial.symbolsKey,
      clearKey: tutorial.clearKey,
      saveKey: tutorial.saveKey,
    );

    return Stack(
      children: [
        IgnorePointer(
          ignoring: tutorial.isTutorialActive,
          child: ExcludeSemantics(
            excluding: tutorial.isTutorialActive,
            child: homeScreen,
          ),
        ),

        // Camada do tutorial.
        if (tutorial.isTutorialActive) _buildTutorialLayer(tutorial),

        // VLibras igual ao Mathnew:
        // aparece no canto direito, depois da camada do tutorial.
        if (tutorial.isTutorialActive)
          const Positioned(
            bottom: 0,
            right: 0,
            child: ExcludeSemantics(
              child: VLibrasWidget(),
            ),
          ),
      ],
    );
  }

  void _finishOrSkipTutorial(
    CombinatoricsTutorialController tutorial,
  ) {
    context.read<CombinatoricsController>().resetAfterTutorial();
    tutorial.skipTutorial();
  }

  Widget _buildTutorialLayer(CombinatoricsTutorialController tutorial) {
    final bool isLastStep =
        tutorial.currentStepIndex == tutorial.totalSteps - 1;
    final bool isFirstStep = tutorial.currentStepIndex == 0;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final bool isSwipeNext =
            details.primaryVelocity != null && details.primaryVelocity! < 0;

        if (isSwipeNext && !isFirstStep && !isLastStep) {
          tutorial.nextStep();
        }
      },
      child: Semantics(
        label: 'Camada do tutorial',
        scopesRoute: true,
        explicitChildNodes: true,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {},
              child: ClipPath(
                clipper: HoleClipper(tutorial.highlightRect),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.75),
                ),
              ),
            ),
            _buildGuidanceBox(tutorial),
            if (!isLastStep) _buildNextButton(tutorial),
            if (!isLastStep) _buildSkipButton(tutorial),
            if (isLastStep) _buildFinishButton(tutorial),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidanceBox(CombinatoricsTutorialController tutorial) {
    if (tutorial.guidanceText.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double fontSize = (screenWidth * 0.024).clamp(15.0, 26.0);
    final double maxBoxWidth = screenWidth * 0.70;

    if (tutorial.guidanceAlignment == Alignment.center ||
        tutorial.highlightRect == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: maxBoxWidth,
          margin: const EdgeInsets.only(left: 40),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Semantics(
            liveRegion: true,
            child: Text(
              tutorial.guidanceText,
              style: TextStyle(
                fontSize: fontSize,
                color: const Color(0xFF2563EB),
                fontWeight: FontWeight.w900,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final rect = tutorial.highlightRect!;
    double top;

    if (tutorial.guidanceAlignment == Alignment.topCenter) {
      top = rect.bottom + 20;
    } else {
      top = rect.top - 130;
    }

    if (top < 10) top = 10;
    if (top > screenHeight - 120) top = screenHeight - 120;

    return Positioned(
      top: top,
      left: 30,
      width: maxBoxWidth - 30,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Semantics(
          liveRegion: true,
          child: Text(
            tutorial.guidanceText,
            style: TextStyle(
              fontSize: fontSize,
              color: const Color(0xFF2563EB),
              fontWeight: FontWeight.w900,
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(CombinatoricsTutorialController tutorial) {
    final bool isWelcomeStep = tutorial.currentStepIndex == 0;
    final screenWidth = MediaQuery.of(context).size.width;

    final double btnFontSize = (screenWidth * 0.022).clamp(16.0, 28.0);
    final double padH = (screenWidth * 0.03).clamp(24.0, 50.0);
    final double padV = (screenWidth * 0.015).clamp(12.0, 24.0);

    return Positioned(
      bottom: 20,

      // Igual ao Mathnew:
      // afasta o botão do canto direito para não ficar embaixo do VLibras.
      right: (screenWidth * 0.25) + 20,

      child: Semantics(
        button: true,
        label: isWelcomeStep ? 'Começar tutorial' : 'Próximo passo do tutorial',
        child: ElevatedButton(
          onPressed: tutorial.nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: padH,
              vertical: padV,
            ),
            textStyle: TextStyle(
              fontSize: btnFontSize,
              fontWeight: FontWeight.w900,
            ),
          ),
          child: Text(isWelcomeStep ? 'Começar' : 'Próximo'),
        ),
      ),
    );
  }

  Widget _buildSkipButton(CombinatoricsTutorialController tutorial) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = (screenWidth * 0.022).clamp(16.0, 28.0);

    return Positioned(
      bottom: 20,
      left: 20,
      child: TextButton(
        onPressed: () {
          _finishOrSkipTutorial(tutorial);
        },
        child: Text(
          'Pular Tutorial',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: fontSize,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFinishButton(CombinatoricsTutorialController tutorial) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double btnFontSize = (screenWidth * 0.022).clamp(16.0, 28.0);
    final double padH = (screenWidth * 0.03).clamp(24.0, 50.0);
    final double padV = (screenWidth * 0.015).clamp(12.0, 24.0);

    return Positioned(
      bottom: 20,

      // Também afasta o botão Finalizar do VLibras.
      right: (screenWidth * 0.25) + 20,

      child: Semantics(
        button: true,
        label: 'Finalizar tutorial',
        child: ElevatedButton(
          onPressed: () {
            _finishOrSkipTutorial(tutorial);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF16A34A),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: padH,
              vertical: padV,
            ),
            textStyle: TextStyle(
              fontSize: btnFontSize,
              fontWeight: FontWeight.w900,
            ),
          ),
          child: const Text('Finalizar Tutorial'),
        ),
      ),
    );
  }
}
