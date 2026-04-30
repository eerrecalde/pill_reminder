enum MedicationStatus {
  active,
  inactive;

  static MedicationStatus fromStorage(String? value) {
    return switch (value) {
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
  });

  final String id;
  final String name;
  final String dosageLabel;
  final String notes;
  final MedicationStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isActive => status == MedicationStatus.active;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'dosageLabel': dosageLabel,
      'notes': notes,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
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
    );
  }
}
