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
      id: 0, label: '0', solfege: 'Dó', pitch: 'C4', color: Color(0xFF4338CA)),
  MusicNote(
      id: 1, label: '1', solfege: 'Ré', pitch: 'D4', color: Color(0xFF16A34A)),
  MusicNote(
      id: 2, label: '2', solfege: 'Mi', pitch: 'E4', color: Color(0xFF0284C7)),
  MusicNote(
      id: 3, label: '3', solfege: 'Fá', pitch: 'F4', color: Color(0xFFEAB308)),
  MusicNote(
      id: 4, label: '4', solfege: 'Sol', pitch: 'G4', color: Color(0xFF9333EA)),
  MusicNote(
      id: 5, label: '5', solfege: 'Lá', pitch: 'A4', color: Color(0xFFEA580C)),
  MusicNote(
      id: 6, label: '6', solfege: 'Si', pitch: 'B4', color: Color(0xFFDB2777)),
  MusicNote(
      id: 7,
      label: '7',
      solfege: 'Dó agudo',
      pitch: 'C24',
      color: Color(0xFF92400E)),
  MusicNote(
      id: 8,
      label: '8',
      solfege: 'Ré agudo',
      pitch: 'D24',
      color: Color(0xFF64748B)),
  MusicNote(
      id: 9,
      label: '9',
      solfege: 'Fá agudo',
      pitch: 'F24',
      color: Color(0xFF0891B2)),
];
