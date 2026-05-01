enum MedicationStatus {
  active,
  paused,
  inactive;

  static MedicationStatus fromStorage(String? value) {
    return switch (value) {
      'paused' => MedicationStatus.paused,
      'inactive' => MedicationStatus.inactive,
      _ => MedicationStatus.active,
    };
  }
}

class Medication {
  const Medication({
    required this.id,
    required this.name,
    required this.dosageLabel,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.pausedAt,
    this.resumedAt,
  });

  final String id;
  final String name;
  final String dosageLabel;
  final String notes;
  final MedicationStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? pausedAt;
  final DateTime? resumedAt;

  bool get isActive => status == MedicationStatus.active;
  bool get isPaused => status == MedicationStatus.paused;

  Medication copyWith({
    String? id,
    String? name,
    String? dosageLabel,
    String? notes,
    MedicationStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? pausedAt,
    bool clearPausedAt = false,
    DateTime? resumedAt,
    bool clearResumedAt = false,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosageLabel: dosageLabel ?? this.dosageLabel,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pausedAt: clearPausedAt ? null : pausedAt ?? this.pausedAt,
      resumedAt: clearResumedAt ? null : resumedAt ?? this.resumedAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'dosageLabel': dosageLabel,
      'notes': notes,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'pausedAt': pausedAt?.toIso8601String(),
      'resumedAt': resumedAt?.toIso8601String(),
    };
  }

  factory Medication.fromJson(Map<String, Object?> json) {
    return Medication(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      dosageLabel: json['dosageLabel'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      status: MedicationStatus.fromStorage(json['status'] as String?),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      pausedAt: DateTime.tryParse(json['pausedAt'] as String? ?? ''),
      resumedAt: DateTime.tryParse(json['resumedAt'] as String? ?? ''),
    );
  }
}
