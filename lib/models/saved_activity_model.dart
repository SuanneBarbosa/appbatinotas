class SavedActivityModel {
  final String id;
  final DateTime createdAt;

  final List<int> selectedNoteIds;
  final List<String> selectedNotes;

  final int noteCount;
  final int beatCount;
  final String mode;
  final String instrumentId;
  final String instrument;

  final String expectedTotal;
  final String expectedCalculation;
  final String expectedGeneralRule;

  final String studentFoundTotal;
  final String studentCalculation;
  final String studentGeneralRule;
  final String studentExplanation;

  const SavedActivityModel({
    required this.id,
    required this.createdAt,
    required this.selectedNoteIds,
    required this.selectedNotes,
    required this.noteCount,
    required this.beatCount,
    required this.mode,
    required this.instrumentId,
    required this.instrument,
    required this.expectedTotal,
    required this.expectedCalculation,
    required this.expectedGeneralRule,
    required this.studentFoundTotal,
    required this.studentCalculation,
    required this.studentGeneralRule,
    required this.studentExplanation,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'selectedNoteIds': selectedNoteIds,
      'selectedNotes': selectedNotes,
      'noteCount': noteCount,
      'beatCount': beatCount,
      'mode': mode,
      'instrumentId': instrumentId,
      'instrument': instrument,
      'expectedTotal': expectedTotal,
      'expectedCalculation': expectedCalculation,
      'expectedGeneralRule': expectedGeneralRule,
      'studentFoundTotal': studentFoundTotal,
      'studentCalculation': studentCalculation,
      'studentGeneralRule': studentGeneralRule,
      'studentExplanation': studentExplanation,
    };
  }

  factory SavedActivityModel.fromJson(Map<String, dynamic> json) {
    return SavedActivityModel(
      id: json['id'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      selectedNoteIds: List<int>.from(json['selectedNoteIds'] ?? []),
      selectedNotes: List<String>.from(json['selectedNotes'] ?? []),
      noteCount: json['noteCount'] ?? 0,
      beatCount: json['beatCount'] ?? 0,
      mode: json['mode'] ?? '',
      instrumentId: json['instrumentId'] ?? '',
      instrument: json['instrument'] ?? '',
      expectedTotal: json['expectedTotal'] ?? '',
      expectedCalculation: json['expectedCalculation'] ?? '',
      expectedGeneralRule: json['expectedGeneralRule'] ?? '',
      studentFoundTotal: json['studentFoundTotal'] ?? '',
      studentCalculation: json['studentCalculation'] ?? '',
      studentGeneralRule: json['studentGeneralRule'] ?? '',
      studentExplanation: json['studentExplanation'] ?? '',
    );
  }
}
