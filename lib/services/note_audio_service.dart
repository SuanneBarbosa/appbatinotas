import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../models/instrument.dart';
import '../models/music_note.dart';

class NoteAudioService {
  final AudioPlayer _player = AudioPlayer();

  Instrument selectedInstrument = availableInstruments.first;

  int noteDurationMs = 400;
  int delayMs = 80;

  NoteAudioService() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  String _buildAssetPath(MusicNote note) {
    final instrumentFolder = selectedInstrument.id;
    final filePrefix = selectedInstrument.filePrefix;

    return 'sounds/$instrumentFolder/${note.pitch}_$filePrefix.mp3';
  }

  Future<void> playNote(MusicNote note) async {
    final assetPath = _buildAssetPath(note);

    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath));

      await Future<void>.delayed(
        Duration(milliseconds: noteDurationMs),
      );
    } catch (e) {
      debugPrint('Erro ao tocar nota: $assetPath');
      debugPrint(e.toString());
    }
  }

  Future<void> playMelody(
    List<MusicNote> melody, {
    void Function(int index)? onNote,
  }) async {
    for (int i = 0; i < melody.length; i++) {
      onNote?.call(i);

      await playNote(melody[i]);

      if (delayMs > 0 && i < melody.length - 1) {
        await Future<void>.delayed(
          Duration(milliseconds: delayMs),
        );
      }
    }

    onNote?.call(-1);
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
