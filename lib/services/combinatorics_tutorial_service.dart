import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../user_interface/widgets/vlibras_widget.dart';
import 'orientation_service.dart';

class CombinatoricsTutorialController extends ChangeNotifier {
  int _currentStepIndex = -1;
  List<VoidCallback> _tutorialSteps = [];

  bool get isTutorialActive => _currentStepIndex < _tutorialSteps.length;
  int get currentStepIndex => _currentStepIndex;
  int get totalSteps => _tutorialSteps.length;

  bool _isInitialized = false;

  final menuKey = GlobalKey();
  final notesKey = GlobalKey();
  final modeKey = GlobalKey();
  final beatKey = GlobalKey();
  final examplesKey = GlobalKey();
  final resultKey = GlobalKey();
  final symbolsKey = GlobalKey();
  final clearKey = GlobalKey();
  final saveKey = GlobalKey();

  Rect? highlightRect;
  String guidanceText = '';
  Alignment guidanceAlignment = Alignment.center;

  final OrientationService _orientationService = OrientationService();

  Future<void> start(BuildContext context) async {
    final alreadyShown =
        await _orientationService.hasShownCombinatoricsTutorial();

    if (alreadyShown) {
      _currentStepIndex = 999;
      notifyListeners();
      return;
    }

    _buildTutorialSequence();
    _isInitialized = true;
    nextStep();
  }

  void restart(BuildContext context) {
    _buildTutorialSequence();
    _isInitialized = true;
    _currentStepIndex = -1;
    nextStep();
  }

  void _buildTutorialSequence() {
    _tutorialSteps = [
      _stepVLibrasIntro,
      _stepMenu,
      _stepNotes,
      _stepMode,
      _stepBeats,
      _stepExamples,
      _stepResults,
      _stepSymbols,
      _stepClear,
      _stepSave,
      _stepEnd,
    ];
  }

  void nextStep() {
    _currentStepIndex++;

    if (isTutorialActive) {
      _tutorialSteps[_currentStepIndex]();
    } else {
      _finishTutorial();
    }
  }

  void skipTutorial() {
    _finishTutorial();
  }

  void _stepVLibrasIntro() {
    highlightRect = null;
    guidanceText =
        'Ative o VLibras no ícone à direita depois toque em "Começar" ou apenas em "Começar" para seguir sem a tradução.';
    guidanceAlignment = Alignment.center;
    _announce(guidanceText);
    notifyListeners();
  }

  void _stepNotes() {
    _calculateHighlight(notesKey);
    guidanceText =
        'Escolha as notas musicais. A quantidade de notas escolhidas representa o valor de n.';
    guidanceAlignment = Alignment.bottomCenter;
    _announce(guidanceText);
    notifyListeners();
  }

  void _stepMode() {
    _calculateHighlight(modeKey);
    guidanceText =
        'Escolha o tipo de formação: com repetição ou sem repetição.';
    guidanceAlignment = Alignment.bottomCenter;
    _announce(guidanceText);
    notifyListeners();
  }

  void _stepBeats() {
    _calculateHighlight(beatKey);
    guidanceText =
        'Escolha o número de batidas. A quantidade de batidas representa o valor de b.';
    guidanceAlignment = Alignment.bottomCenter;
    _announce(guidanceText);
    notifyListeners();
  }

  void _stepExamples() {
    _calculateHighlight(examplesKey);
    guidanceText =
        'As musicas formadas ficam agrupadas em lista com até 64 opções de combinações que podem ser reproduzidas.';
    guidanceAlignment = Alignment.center;
    _announce(guidanceText);
    notifyListeners();
  }

  void _stepResults() {
    _calculateHighlight(resultKey);
    guidanceText =
        'Na seção de resultados, responda às perguntas: quantas músicas foram encontradas e qual a regra geral.';
    guidanceAlignment = Alignment.center;
    _announce(guidanceText);
    notifyListeners();
  }

  void _stepSymbols() {
    _calculateHighlight(symbolsKey);
    guidanceText = 'Use os símbolos disponíveis para escrever a regra geral.';
    guidanceAlignment = Alignment.bottomCenter;
    _announce(guidanceText);
    notifyListeners();
  }

  void _stepEnd() {
    highlightRect = null;
    guidanceText =
        'Tutorial finalizado. Toque em "Finalizar Tutorial" para começar a atividade.';
    guidanceAlignment = Alignment.center;
    _announce(guidanceText);
    notifyListeners();
  }

  void _stepMenu() {
    _calculateHighlight(menuKey);
    guidanceText =
        'No menu encontre as opções de instrumento, apresentação das combinações, galeria, instruções e informações sobre o aplicativo.';
    guidanceAlignment = Alignment.topCenter;
    _announce(guidanceText);
    notifyListeners();
  }

  void _stepClear() {
    _calculateHighlight(clearKey);
    guidanceText =
        'O botão Limpar apaga as respostas preenchidas nos campos da seção de resultados.';
    guidanceAlignment = Alignment.center;
    _announce(guidanceText);
    notifyListeners();
  }

  void _stepSave() {
    _calculateHighlight(saveKey);
    guidanceText = 'O botão Salvar guarda a atividade atual na galeria.';
    guidanceAlignment = Alignment.center;
    _announce(guidanceText);
    notifyListeners();
  }

  Future<void> _finishTutorial() async {
    if (!_isInitialized) return;

    _currentStepIndex = _tutorialSteps.length;
    highlightRect = null;
    guidanceText = '';

    await _orientationService.markCombinatoricsTutorialAsShown();

    _announce('Tutorial finalizado!');
    notifyListeners();
  }

  void _calculateHighlight(GlobalKey key) {
    Future.delayed(const Duration(milliseconds: 180), () async {
      if (!isTutorialActive) return;

      final targetContext = key.currentContext;

      if (targetContext == null) {
        highlightRect = null;
        notifyListeners();
        return;
      }

      // Faz a tela rolar automaticamente até o item do tutorial.
      await Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.35,
      );

      // Espera a rolagem terminar e o layout atualizar.
      await Future.delayed(const Duration(milliseconds: 120));

      if (!isTutorialActive) return;

      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox != null && renderBox.hasSize) {
        final position = renderBox.localToGlobal(Offset.zero);

        highlightRect = Rect.fromLTWH(
          position.dx,
          position.dy,
          renderBox.size.width,
          renderBox.size.height,
        );
      } else {
        highlightRect = null;
      }

      notifyListeners();
    });
  }

  void _announce(String message) {
    final bool isLastStep = _currentStepIndex >= _tutorialSteps.length - 1;
    final bool isIntroStep = _currentStepIndex <= 1;

    String messageToSpeak = message;

    VLibrasWidget.buscarTraducao(message);

    if (isTutorialActive && !isLastStep && !isIntroStep) {
      messageToSpeak += '. Toque em próximo para continuar.';
    }

    // ignore: deprecated_member_use
    SemanticsService.announce(messageToSpeak, TextDirection.ltr);
  }
}
