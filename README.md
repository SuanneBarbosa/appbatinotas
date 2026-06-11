# CombinaSom Algébrico

Aplicativo Flutter educacional para Ensino Médio e EJA. O aluno escolhe notas musicais, configura batidas fixas ou livres, compara casos com repetição e sem repetição, ouve/explora sequências e chega à regra geral.

## Objetivo didático

Conduzir o aluno da experimentação concreta à generalização algébrica:

- Com repetição e batidas fixas: `n^b`
- Sem repetição e batidas fixas: `n! / (n-b)!`, quando `b <= n`
- Com repetição e batidas livres: `n^1 + n^2 + n^3 + ...`, infinito
- Sem repetição e batidas livres, com conjunto finito de notas: soma finita de tamanhos `1` até `n`

## Como rodar

```bash
flutter pub get
flutter run
```

## Áudio

O projeto vem com um serviço de áudio simulado para compilar sem assets. Para usar os áudios do MusicalColorida, adapte `lib/services/note_audio_service.dart` para apontar aos arquivos reais e adicione os assets no `pubspec.yaml`.
