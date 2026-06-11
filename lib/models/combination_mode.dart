enum CombinationMode {
  withRepetition,
  withoutRepetition,
}

extension CombinationModeLabel on CombinationMode {
  String get label {
    switch (this) {
      case CombinationMode.withRepetition:
        return 'Com repetição';
      case CombinationMode.withoutRepetition:
        return 'Sem repetição';
    }
  }

  String get description {
    switch (this) {
      case CombinationMode.withRepetition:
        return 'A mesma nota pode aparecer mais de uma vez na música.';
      case CombinationMode.withoutRepetition:
        return 'Cada nota pode aparecer apenas uma vez na música.';
    }
  }
}
