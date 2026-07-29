import 'package:flutter/material.dart';

class MusicNote {
  final int id;
  final String label;
  final String solfege;
  final String pitch;
  final Color color;

  const MusicNote({
    required this.id,
    required this.label,
    required this.solfege,
    required this.pitch,
    required this.color,
  });

  String get semanticsLabel => 'Nota $id, $solfege, som $pitch';
}

const List<MusicNote> defaultNotes = [
  MusicNote(
      id: 1, label: '1', solfege: 'Dó', pitch: 'C4', color: Color(0xFF78350F)),
  MusicNote(
      id: 2, label: '2', solfege: 'Ré', pitch: 'D4', color: Color(0xFF16A34A)),
  MusicNote(
      id: 3, label: '3', solfege: 'Mi', pitch: 'E4', color: Color(0xFF0284C7)),
  MusicNote(
      id: 4, label: '4', solfege: 'Fá', pitch: 'F4', color: Color(0xFFEAB308)),
  MusicNote(
      id: 5, label: '5', solfege: 'Sol', pitch: 'G4', color: Color(0xFF9333EA)),
  MusicNote(
      id: 6, label: '6', solfege: 'Lá', pitch: 'A4', color: Color(0xFFEA580C)),
  MusicNote(
      id: 7, label: '7', solfege: 'Si', pitch: 'B4', color: Color(0xFFDB2777)),
];
