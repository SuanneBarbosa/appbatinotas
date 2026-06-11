class Instrument {
  final String id;
  final String displayName;
  final String filePrefix;

  const Instrument({
    required this.id,
    required this.displayName,
    required this.filePrefix,
  });
}

const List<Instrument> availableInstruments = [
  Instrument(
    id: 'piano',
    displayName: 'Piano Acústico',
    filePrefix: 'Piano_Acustico',
  ),
  Instrument(
    id: 'baixo',
    displayName: 'Baixo Elétrico',
    filePrefix: 'Baixo_Eletrico_Dedo',
  ),
  Instrument(
    id: 'banjo',
    displayName: 'Banjo',
    filePrefix: 'Banjo',
  ),
  Instrument(
    id: 'flauta',
    displayName: 'Flauta',
    filePrefix: 'Flauta',
  ),
  Instrument(
    id: 'flautadoce',
    displayName: 'Flauta Doce',
    filePrefix: 'Flauta_Doce',
  ),
  Instrument(
    id: 'guitarra',
    displayName: 'Guitarra Elétrica',
    filePrefix: 'Guitarra_Eletrica_Limpa',
  ),
  Instrument(
    id: 'orgao',
    displayName: 'Órgão Hammond',
    filePrefix: 'Órgão_Hammond',
  ),
  Instrument(
    id: 'pianoeletrico',
    displayName: 'Piano Elétrico',
    filePrefix: 'Piano_Eletrico_1',
  ),
  Instrument(
    id: 'sitar',
    displayName: 'Sitar',
    filePrefix: 'Sitar',
  ),
  Instrument(
    id: 'trompete',
    displayName: 'Trompete',
    filePrefix: 'Trompete',
  ),
  Instrument(
    id: 'violino',
    displayName: 'Violino',
    filePrefix: 'Violino',
  ),
];
