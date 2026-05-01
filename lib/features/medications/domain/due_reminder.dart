enum DueReminderState {
  unresolved,
  taken,
  skipped,
  remindAgainLater;

  static DueReminderState fromStorage(String? value) {
    return switch (value) {
      'taken' => DueReminderState.taken,
      'skipped' => DueReminderState.skipped,
      'remindAgainLater' => DueReminderState.remindAgainLater,
      _ => DueReminderState.unresolved,
    };
  }

  bool get isFinal => this == taken || this == skipped;
}

enum ReminderActionType {
  taken,
  skipped,
  remindAgainLater;

  static ReminderActionType fromStorage(String? value) {
    return switch (value) {
      'skipped' => ReminderActionType.skipped,
      'remindAgainLater' => ReminderActionType.remindAgainLater,
      _ => ReminderActionType.taken,
    };
  }
}

enum ReminderActionSource {
  notification,
  inApp,
  reconciliation;

  static ReminderActionSource fromStorage(String? value) {
    return switch (value) {
      'notification' => ReminderActionSource.notification,
      'inApp' => ReminderActionSource.inApp,
      _ => ReminderActionSource.reconciliation,
    };
  }
}

enum RemindAgainLaterState {
  pending,
  returnedToUnresolved,
  cancelledByFinalOutcome;

  static RemindAgainLaterState fromStorage(String? value) {
    return switch (value) {
      'returnedToUnresolved' => RemindAgainLaterState.returnedToUnresolved,
      'cancelledByFinalOutcome' =>
        RemindAgainLaterState.cancelledByFinalOutcome,
      _ => RemindAgainLaterState.pending,
    };
  }
}

class ReminderOutcome {
  const ReminderOutcome({
    required this.dueReminderId,
    required this.outcomeType,
    required this.actionTime,
    required this.actionSource,
  });

  final String dueReminderId;
  final ReminderActionType outcomeType;
  final DateTime actionTime;
  final ReminderActionSource actionSource;

  Map<String, Object?> toJson() {
    return {
      'dueReminderId': dueReminderId,
      'outcomeType': outcomeType.name,
      'actionTime': actionTime.toIso8601String(),
      'actionSource': actionSource.name,
    };
  }

  factory ReminderOutcome.fromJson(Map<String, Object?> json) {
    return ReminderOutcome(
      dueReminderId: json['dueReminderId'] as String? ?? '',
      outcomeType: ReminderActionType.fromStorage(
        json['outcomeType'] as String?,
      ),
      actionTime:
          DateTime.tryParse(json['actionTime'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      actionSource: ReminderActionSource.fromStorage(
        json['actionSource'] as String?,
      ),
    );
  }
}

class RemindAgainLaterRequest {
  const RemindAgainLaterRequest({
    required this.dueReminderId,
    required this.intervalMinutes,
    required this.requestedAt,
    required this.nextReminderAt,
    this.state = RemindAgainLaterState.pending,
  });

  final String dueReminderId;
  final int intervalMinutes;
  final DateTime requestedAt;
  final DateTime nextReminderAt;
  final RemindAgainLaterState state;

  RemindAgainLaterRequest copyWith({
    int? intervalMinutes,
    DateTime? requestedAt,
    DateTime? nextReminderAt,
    RemindAgainLaterState? state,
  }) {
    return RemindAgainLaterRequest(
      dueReminderId: dueReminderId,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      requestedAt: requestedAt ?? this.requestedAt,
      nextReminderAt: nextReminderAt ?? this.nextReminderAt,
      state: state ?? this.state,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'dueReminderId': dueReminderId,
      'intervalMinutes': intervalMinutes,
      'requestedAt': requestedAt.toIso8601String(),
      'nextReminderAt': nextReminderAt.toIso8601String(),
      'state': state.name,
    };
  }

  factory RemindAgainLaterRequest.fromJson(Map<String, Object?> json) {
    return RemindAgainLaterRequest(
      dueReminderId: json['dueReminderId'] as String? ?? '',
      intervalMinutes: json['intervalMinutes'] as int? ?? 10,
      requestedAt:
          DateTime.tryParse(json['requestedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      nextReminderAt:
          DateTime.tryParse(json['nextReminderAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      state: RemindAgainLaterState.fromStorage(json['state'] as String?),
    );
  }
}

class NotificationActionRequest {
  const NotificationActionRequest({
    required this.dueReminderId,
    required this.actionType,
    required this.receivedAt,
  });

  final String dueReminderId;
  final ReminderActionType actionType;
  final DateTime receivedAt;
}

class DueReminder {
  const DueReminder({
    required this.id,
    required this.medicationId,
    required this.scheduleId,
    required this.scheduledAt,
    required this.medicationName,
    required this.createdAt,
    required this.updatedAt,
    this.dosageLabel = '',
    this.state = DueReminderState.unresolved,
    this.resolvedAt,
    this.lastActionSource = ReminderActionSource.reconciliation,
    this.outcome,
    this.remindAgainLaterRequest,
  });

  final String id;
  final String medicationId;
  final String scheduleId;
  final DateTime scheduledAt;
  final String medicationName;
  final String dosageLabel;
  final DueReminderState state;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;
  final ReminderActionSource lastActionSource;
  final ReminderOutcome? outcome;
  final RemindAgainLaterRequest? remindAgainLaterRequest;

  bool get isFinal => state.isFinal;

  static String stableId({
    required String medicationId,
    required DateTime scheduledAt,
  }) {
    final occurrence = DateTime(
      scheduledAt.year,
      scheduledAt.month,
      scheduledAt.day,
      scheduledAt.hour,
      scheduledAt.minute,
    ).toIso8601String();
    return '$medicationId@$occurrence';
  }

  factory DueReminder.create({
    required String medicationId,
    required String scheduleId,
    required DateTime scheduledAt,
    required String medicationName,
    String dosageLabel = '',
    DateTime? now,
  }) {
    final timestamp = now ?? DateTime.now();
    return DueReminder(
      id: stableId(medicationId: medicationId, scheduledAt: scheduledAt),
      medicationId: medicationId,
      scheduleId: scheduleId,
      scheduledAt: scheduledAt,
      medicationName: medicationName,
      dosageLabel: dosageLabel,
      createdAt: timestamp,
      updatedAt: timestamp,
    );
  }

  DueReminder copyWith({
    String? medicationName,
    String? dosageLabel,
    DueReminderState? state,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    bool clearResolvedAt = false,
    ReminderActionSource? lastActionSource,
    ReminderOutcome? outcome,
    bool clearOutcome = false,
    RemindAgainLaterRequest? remindAgainLaterRequest,
    bool clearRemindAgainLaterRequest = false,
  }) {
    return DueReminder(
      id: id,
      medicationId: medicationId,
      scheduleId: scheduleId,
      scheduledAt: scheduledAt,
      medicationName: medicationName ?? this.medicationName,
      dosageLabel: dosageLabel ?? this.dosageLabel,
      state: state ?? this.state,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: clearResolvedAt ? null : resolvedAt ?? this.resolvedAt,
      lastActionSource: lastActionSource ?? this.lastActionSource,
      outcome: clearOutcome ? null : outcome ?? this.outcome,
      remindAgainLaterRequest: clearRemindAgainLaterRequest
          ? null
          : remindAgainLaterRequest ?? this.remindAgainLaterRequest,
    );
  }

  DueReminder markTaken({
    required DateTime at,
    required ReminderActionSource source,
  }) {
    if (isFinal) return this;
    final finalOutcome = ReminderOutcome(
      dueReminderId: id,
      outcomeType: ReminderActionType.taken,
      actionTime: at,
      actionSource: source,
    );
    return copyWith(
      state: DueReminderState.taken,
      updatedAt: at,
      resolvedAt: at,
      lastActionSource: source,
      outcome: finalOutcome,
      clearRemindAgainLaterRequest: true,
    );
  }

  DueReminder markSkipped({
    required DateTime at,
    required ReminderActionSource source,
  }) {
    if (isFinal) return this;
    final finalOutcome = ReminderOutcome(
      dueReminderId: id,
      outcomeType: ReminderActionType.skipped,
      actionTime: at,
      actionSource: source,
    );
    return copyWith(
      state: DueReminderState.skipped,
      updatedAt: at,
      resolvedAt: at,
      lastActionSource: source,
      outcome: finalOutcome,
      clearRemindAgainLaterRequest: true,
    );
  }

  DueReminder remindAgainLater({
    required DateTime requestedAt,
    required int intervalMinutes,
    required ReminderActionSource source,
  }) {
    if (isFinal) return this;
    final request = RemindAgainLaterRequest(
      dueReminderId: id,
      intervalMinutes: intervalMinutes,
      requestedAt: requestedAt,
      nextReminderAt: requestedAt.add(Duration(minutes: intervalMinutes)),
    );
    return copyWith(
      state: DueReminderState.remindAgainLater,
      updatedAt: requestedAt,
      clearResolvedAt: true,
      lastActionSource: source,
      clearOutcome: true,
      remindAgainLaterRequest: request,
    );
  }

  DueReminder returnToUnresolved({required DateTime at}) {
    if (isFinal) return this;
    return copyWith(
      state: DueReminderState.unresolved,
      updatedAt: at,
      clearResolvedAt: true,
      clearOutcome: true,
      remindAgainLaterRequest: remindAgainLaterRequest?.copyWith(
        state: RemindAgainLaterState.returnedToUnresolved,
      ),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'medicationId': medicationId,
      'scheduleId': scheduleId,
      'scheduledAt': scheduledAt.toIso8601String(),
      'medicationName': medicationName,
      'dosageLabel': dosageLabel,
      'state': state.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'lastActionSource': lastActionSource.name,
      'outcome': outcome?.toJson(),
      'remindAgainLaterRequest': remindAgainLaterRequest?.toJson(),
    };
  }

  factory DueReminder.fromJson(Map<String, Object?> json) {
    final outcome = json['outcome'];
    final request = json['remindAgainLaterRequest'];
    return DueReminder(
      id: json['id'] as String? ?? '',
      medicationId: json['medicationId'] as String? ?? '',
      scheduleId: json['scheduleId'] as String? ?? '',
      scheduledAt:
          DateTime.tryParse(json['scheduledAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      medicationName: json['medicationName'] as String? ?? '',
      dosageLabel: json['dosageLabel'] as String? ?? '',
      state: DueReminderState.fromStorage(json['state'] as String?),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      resolvedAt: DateTime.tryParse(json['resolvedAt'] as String? ?? ''),
      lastActionSource: ReminderActionSource.fromStorage(
        json['lastActionSource'] as String?,
      ),
      outcome: outcome is Map<String, Object?>
          ? ReminderOutcome.fromJson(outcome)
          : null,
      remindAgainLaterRequest: request is Map<String, Object?>
          ? RemindAgainLaterRequest.fromJson(request)
          : null,
    );
  }
}
