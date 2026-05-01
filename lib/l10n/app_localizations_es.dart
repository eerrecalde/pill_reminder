// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Recordatorio de medicamentos';

  @override
  String get mainTitle => 'Hoy';

  @override
  String get mainPlaceholder => 'Tus recordatorios aparecerán aquí.';

  @override
  String get setupPreferences => 'Preferencias de inicio';

  @override
  String get chooseLanguage => 'Elige tu idioma';

  @override
  String get english => 'English';

  @override
  String get spanishLatinAmerica => 'Español (Latinoamérica)';

  @override
  String get selected => 'Seleccionado';

  @override
  String get back => 'Atrás';

  @override
  String get yourInformationStaysWithYou => 'Tu información se queda contigo';

  @override
  String get privacyBodyLineOne =>
      'Tus recordatorios de medicamentos se guardan solo en este dispositivo.';

  @override
  String get privacyBodyLineTwo => 'Sin cuenta. Sin compartir.';

  @override
  String get continueAction => 'Continuar';

  @override
  String get getReminderAlerts => 'Recibe avisos de recordatorio';

  @override
  String get notificationBody =>
      'Podemos avisarte cuando sea hora de tomar tu medicamento.';

  @override
  String get turnOnReminders => 'Activar recordatorios';

  @override
  String get notNow => 'Ahora no';

  @override
  String get remindersOn => 'Los recordatorios están activados';

  @override
  String get remindersUnavailableTitle => 'Los avisos están desactivados';

  @override
  String get remindersUnavailableBody =>
      'Los recordatorios no se pueden entregar hasta que actives las notificaciones.';

  @override
  String get openSettings => 'Abrir configuración';

  @override
  String get languageSettingTitle => 'Idioma';

  @override
  String get notificationSettingTitle => 'Avisos de recordatorio';

  @override
  String get notificationSettingGranted =>
      'Los avisos de recordatorio se pueden entregar.';

  @override
  String get notificationSettingSkipped =>
      'Los avisos están desactivados. Puedes activarlos cuando quieras.';

  @override
  String get notificationSettingDenied =>
      'Los avisos están desactivados hasta que actives las notificaciones.';

  @override
  String get notificationSettingBlocked =>
      'Debes activar los avisos en la configuración del dispositivo.';

  @override
  String get notificationSettingUnavailable =>
      'Los avisos no están disponibles en este dispositivo.';

  @override
  String get changeLanguageHelp =>
      'Elige el idioma para la guía de inicio y recordatorios.';

  @override
  String get addMedicationTitle => 'Agregar medicamento';

  @override
  String get medicationsSectionTitle => 'Medicamentos';

  @override
  String get medicationsEmptyTitle => 'Todavía no hay medicamentos guardados';

  @override
  String get medicationsEmptyBody =>
      'Agrega un medicamento ahora para poder elegirlo en recordatorios más adelante.';

  @override
  String get medicationNameLabel => 'Nombre del medicamento (obligatorio)';

  @override
  String get medicationNameHint => 'Por ejemplo, pastilla de la mañana';

  @override
  String get medicationDosageLabel => 'Etiqueta de dosis (opcional)';

  @override
  String get medicationDosageHint => 'Por ejemplo, 1 tableta';

  @override
  String get medicationNotesLabel => 'Notas (opcional)';

  @override
  String get medicationNotesHint => 'Algo que quieras recordar';

  @override
  String get medicationStatusSemantics => 'Estado del medicamento';

  @override
  String get medicationStatusActive => 'Activo';

  @override
  String get medicationStatusInactive => 'Inactivo';

  @override
  String get medicationStatusActiveSemantics => 'Estado, activo';

  @override
  String get medicationStatusInactiveSemantics => 'Estado, inactivo';

  @override
  String get medicationAvailableForReminders =>
      'Disponible para configurar recordatorios más adelante.';

  @override
  String get medicationStoredInactive =>
      'Guardado como inactivo. No se tratará como listo para recordatorios.';

  @override
  String get addMedicationPrivacyTitle =>
      'Tu medicamento se queda en este dispositivo';

  @override
  String get addMedicationPrivacyBody =>
      'No necesitas cuenta ni internet para agregarlo.';

  @override
  String get saveMedication => 'Guardar medicamento';

  @override
  String get cancel => 'Cancelar';

  @override
  String get duplicateMedicationTitle => 'Este nombre ya está guardado';

  @override
  String get duplicateMedicationMessage =>
      'Otro medicamento tiene este nombre. Puedes guardar este también si es correcto.';

  @override
  String get saveAnyway => 'Guardar de todos modos';

  @override
  String get goBack => 'Volver';

  @override
  String get medicationSavedSemantics => 'Medicamento guardado';

  @override
  String get medicationNotSavedSemantics => 'El medicamento no se guardó';

  @override
  String get medicationNameRequiredError => 'Ingresa un nombre de medicamento.';

  @override
  String get medicationNameTooLongError =>
      'Usa 80 caracteres o menos para el nombre del medicamento.';

  @override
  String get medicationDosageTooLongError =>
      'Usa 80 caracteres o menos para la etiqueta de dosis.';

  @override
  String get medicationNotesTooLongError =>
      'Usa 500 caracteres o menos para las notas.';

  @override
  String get medicationValidationGenericError => 'Revisa el campo marcado.';

  @override
  String get scheduleReminderTitle => 'Programar recordatorios';

  @override
  String get reminderTimesTitle => 'Horarios de recordatorio';

  @override
  String get reminderTimesHelp => 'Elige hasta cuatro horarios diarios.';

  @override
  String get reminderTimesSemantics => 'Horarios de recordatorio';

  @override
  String get addReminderTime => 'Agregar horario';

  @override
  String get editReminderTime => 'Editar horario';

  @override
  String get removeReminderTime => 'Quitar horario';

  @override
  String reminderTimeSemantics(Object time) {
    return 'Horario de recordatorio $time';
  }

  @override
  String get addOptionalEndDate => 'Agregar fecha final opcional';

  @override
  String get clearEndDate => 'Quitar fecha final';

  @override
  String get reviewScheduleTitle => 'Revisar horario';

  @override
  String scheduleMedicationSummary(Object name) {
    return 'Medicamento: $name';
  }

  @override
  String scheduleTimesSummary(Object times) {
    return 'Horarios: $times';
  }

  @override
  String get scheduleRepeatsIndefinitely =>
      'Se repite todos los días hasta que lo edites o elimines.';

  @override
  String scheduleStopsOn(Object date) {
    return 'Termina el $date';
  }

  @override
  String get saveSchedule => 'Guardar horario';

  @override
  String get scheduleSavedSemantics => 'Horario de recordatorios guardado';

  @override
  String get scheduleNotificationsDeliverable =>
      'Los avisos de recordatorio se pueden entregar.';

  @override
  String get scheduleNotificationsNeedPermission =>
      'Horario guardado. Debes activar las notificaciones para recibir avisos.';

  @override
  String get scheduleNotificationsBlocked =>
      'Horario guardado. Activa las notificaciones en la configuración del dispositivo para recibir avisos.';

  @override
  String get scheduleNotificationsUnavailable =>
      'Horario guardado. Los avisos no están disponibles en este dispositivo.';

  @override
  String get scheduleInactiveMedicationError =>
      'Activa este medicamento antes de programar recordatorios.';

  @override
  String get scheduleMissingTimeError =>
      'Elige al menos un horario de recordatorio.';

  @override
  String get scheduleDuplicateTimeError => 'Este horario ya está seleccionado.';

  @override
  String get scheduleTooManyTimesError => 'Usa cuatro horarios o menos.';

  @override
  String get scheduleInvalidEndDateError =>
      'Elige una fecha final en o después de la primera fecha de recordatorio.';

  @override
  String get todayDueNowTitle => 'Toca ahora';

  @override
  String get todayUpcomingTitle => 'Más tarde';

  @override
  String get todayMissedTitle => 'Pendientes';

  @override
  String get todayHandledTitle => 'Hechos hoy';

  @override
  String get todayClearTitle => 'El resto del día está libre';

  @override
  String get todayClearBody =>
      'No hay más recordatorios de medicamentos que necesiten atención hoy.';

  @override
  String get todayNoMedicationsTitle => 'Todavía no hay medicamentos guardados';

  @override
  String get todayNoMedicationsBody =>
      'Agrega tu primer medicamento para poder configurar recordatorios cuando quieras.';

  @override
  String get todayNoActiveMedicationsTitle =>
      'No hay medicamentos activos ahora';

  @override
  String get todayNoActiveMedicationsBody =>
      'Tus medicamentos guardados están inactivos, así que no aparecerán como pendientes hoy.';

  @override
  String get todayNoSchedulesTitle =>
      'Todavía no hay recordatorios programados';

  @override
  String get todayNoSchedulesBody =>
      'Programa un recordatorio para un medicamento activo y lo verás aquí hoy.';

  @override
  String get todayManageMedications => 'Administrar medicamentos';

  @override
  String get todayMarkHandled => 'Marcar hecho';

  @override
  String todayReminderTime(Object time) {
    return '$time';
  }

  @override
  String get dueReminderTitle => 'Recordatorio de medicamento';

  @override
  String dueReminderScheduledTime(Object time) {
    return 'Programado para $time';
  }

  @override
  String get todayReminderStatusDueNow => 'Toca ahora';

  @override
  String get todayReminderStatusUpcoming => 'Próximo';

  @override
  String get todayReminderStatusMissed => 'Pendiente';

  @override
  String get todayReminderStatusHandled => 'Hecho';

  @override
  String todayReminderSemantics(Object medication, Object time, Object status) {
    return '$medication, $time, $status';
  }

  @override
  String todayReminderSemanticsWithDose(
    Object medication,
    Object dose,
    Object time,
    Object status,
  ) {
    return '$medication, $dose, $time, $status';
  }

  @override
  String todayMarkHandledSemantics(Object medication, Object time) {
    return 'Marcar $medication de las $time como hecho';
  }

  @override
  String get todayNotificationGuidance =>
      'Los avisos pueden necesitar permiso de notificaciones, pero el horario de hoy igual se muestra aquí.';

  @override
  String get dueReminderStateUnresolved => 'Este recordatorio está pendiente.';

  @override
  String get dueReminderStateTaken => 'Marcado como tomado.';

  @override
  String get dueReminderStateSkipped => 'Omitido.';

  @override
  String get dueReminderStateLater => 'Te recordaremos de nuevo más tarde.';

  @override
  String get dueReminderTakenAction => 'Tomado';

  @override
  String get dueReminderSkipAction => 'Omitir';

  @override
  String get dueReminderLaterAction => 'Recordar después';

  @override
  String get dueReminderPermissionNeeded =>
      'Debes activar las notificaciones para recibir avisos. Puedes atender este recordatorio aquí.';

  @override
  String get dueReminderPermissionBlocked =>
      'Activa las notificaciones en la configuración del dispositivo. Puedes atender este recordatorio aquí.';

  @override
  String get dueReminderPermissionUnavailable =>
      'Los avisos no están disponibles en este dispositivo. Puedes atender este recordatorio aquí.';

  @override
  String get dueReminderBannerTitle => 'Recordatorios pendientes';

  @override
  String dueReminderBannerItem(Object name) {
    return '$name está pendiente';
  }

  @override
  String dueReminderBannerSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recordatorios pendientes',
      one: '1 recordatorio pendiente',
    );
    return '$_temp0';
  }

  @override
  String get reminderHandlingSettingsTitle => 'Manejo de recordatorios';

  @override
  String get reminderHandlingIntervalLabel => 'Recordar después de';
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');

  @override
  String get appTitle => 'Recordatorio de medicamentos';

  @override
  String get mainTitle => 'Hoy';

  @override
  String get mainPlaceholder => 'Tus recordatorios aparecerán aquí.';

  @override
  String get setupPreferences => 'Preferencias de inicio';

  @override
  String get chooseLanguage => 'Elige tu idioma';

  @override
  String get english => 'English';

  @override
  String get spanishLatinAmerica => 'Español (Latinoamérica)';

  @override
  String get selected => 'Seleccionado';

  @override
  String get back => 'Atrás';

  @override
  String get yourInformationStaysWithYou => 'Tu información se queda contigo';

  @override
  String get privacyBodyLineOne =>
      'Tus recordatorios de medicamentos se guardan solo en este dispositivo.';

  @override
  String get privacyBodyLineTwo => 'Sin cuenta. Sin compartir.';

  @override
  String get continueAction => 'Continuar';

  @override
  String get getReminderAlerts => 'Recibe avisos de recordatorio';

  @override
  String get notificationBody =>
      'Podemos avisarte cuando sea hora de tomar tu medicamento.';

  @override
  String get turnOnReminders => 'Activar recordatorios';

  @override
  String get notNow => 'Ahora no';

  @override
  String get remindersOn => 'Los recordatorios están activados';

  @override
  String get remindersUnavailableTitle => 'Los avisos están desactivados';

  @override
  String get remindersUnavailableBody =>
      'Los recordatorios no se pueden entregar hasta que actives las notificaciones.';

  @override
  String get openSettings => 'Abrir configuración';

  @override
  String get languageSettingTitle => 'Idioma';

  @override
  String get notificationSettingTitle => 'Avisos de recordatorio';

  @override
  String get notificationSettingGranted =>
      'Los avisos de recordatorio se pueden entregar.';

  @override
  String get notificationSettingSkipped =>
      'Los avisos están desactivados. Puedes activarlos cuando quieras.';

  @override
  String get notificationSettingDenied =>
      'Los avisos están desactivados hasta que actives las notificaciones.';

  @override
  String get notificationSettingBlocked =>
      'Debes activar los avisos en la configuración del dispositivo.';

  @override
  String get notificationSettingUnavailable =>
      'Los avisos no están disponibles en este dispositivo.';

  @override
  String get changeLanguageHelp =>
      'Elige el idioma para la guía de inicio y recordatorios.';

  @override
  String get addMedicationTitle => 'Agregar medicamento';

  @override
  String get medicationsSectionTitle => 'Medicamentos';

  @override
  String get medicationsEmptyTitle => 'Todavía no hay medicamentos guardados';

  @override
  String get medicationsEmptyBody =>
      'Agrega un medicamento ahora para poder elegirlo en recordatorios más adelante.';

  @override
  String get medicationNameLabel => 'Nombre del medicamento (obligatorio)';

  @override
  String get medicationNameHint => 'Por ejemplo, pastilla de la mañana';

  @override
  String get medicationDosageLabel => 'Etiqueta de dosis (opcional)';

  @override
  String get medicationDosageHint => 'Por ejemplo, 1 tableta';

  @override
  String get medicationNotesLabel => 'Notas (opcional)';

  @override
  String get medicationNotesHint => 'Algo que quieras recordar';

  @override
  String get medicationStatusSemantics => 'Estado del medicamento';

  @override
  String get medicationStatusActive => 'Activo';

  @override
  String get medicationStatusInactive => 'Inactivo';

  @override
  String get medicationStatusActiveSemantics => 'Estado, activo';

  @override
  String get medicationStatusInactiveSemantics => 'Estado, inactivo';

  @override
  String get medicationAvailableForReminders =>
      'Disponible para configurar recordatorios más adelante.';

  @override
  String get medicationStoredInactive =>
      'Guardado como inactivo. No se tratará como listo para recordatorios.';

  @override
  String get addMedicationPrivacyTitle =>
      'Tu medicamento se queda en este dispositivo';

  @override
  String get addMedicationPrivacyBody =>
      'No necesitas cuenta ni internet para agregarlo.';

  @override
  String get saveMedication => 'Guardar medicamento';

  @override
  String get cancel => 'Cancelar';

  @override
  String get duplicateMedicationTitle => 'Este nombre ya está guardado';

  @override
  String get duplicateMedicationMessage =>
      'Otro medicamento tiene este nombre. Puedes guardar este también si es correcto.';

  @override
  String get saveAnyway => 'Guardar de todos modos';

  @override
  String get goBack => 'Volver';

  @override
  String get medicationSavedSemantics => 'Medicamento guardado';

  @override
  String get medicationNotSavedSemantics => 'El medicamento no se guardó';

  @override
  String get medicationNameRequiredError => 'Ingresa un nombre de medicamento.';

  @override
  String get medicationNameTooLongError =>
      'Usa 80 caracteres o menos para el nombre del medicamento.';

  @override
  String get medicationDosageTooLongError =>
      'Usa 80 caracteres o menos para la etiqueta de dosis.';

  @override
  String get medicationNotesTooLongError =>
      'Usa 500 caracteres o menos para las notas.';

  @override
  String get medicationValidationGenericError => 'Revisa el campo marcado.';

  @override
  String get scheduleReminderTitle => 'Programar recordatorios';

  @override
  String get reminderTimesTitle => 'Horarios de recordatorio';

  @override
  String get reminderTimesHelp => 'Elige hasta cuatro horarios diarios.';

  @override
  String get reminderTimesSemantics => 'Horarios de recordatorio';

  @override
  String get addReminderTime => 'Agregar horario';

  @override
  String get editReminderTime => 'Editar horario';

  @override
  String get removeReminderTime => 'Quitar horario';

  @override
  String reminderTimeSemantics(Object time) {
    return 'Horario de recordatorio $time';
  }

  @override
  String get addOptionalEndDate => 'Agregar fecha final opcional';

  @override
  String get clearEndDate => 'Quitar fecha final';

  @override
  String get reviewScheduleTitle => 'Revisar horario';

  @override
  String scheduleMedicationSummary(Object name) {
    return 'Medicamento: $name';
  }

  @override
  String scheduleTimesSummary(Object times) {
    return 'Horarios: $times';
  }

  @override
  String get scheduleRepeatsIndefinitely =>
      'Se repite todos los días hasta que lo edites o elimines.';

  @override
  String scheduleStopsOn(Object date) {
    return 'Termina el $date';
  }

  @override
  String get saveSchedule => 'Guardar horario';

  @override
  String get scheduleSavedSemantics => 'Horario de recordatorios guardado';

  @override
  String get scheduleNotificationsDeliverable =>
      'Los avisos de recordatorio se pueden entregar.';

  @override
  String get scheduleNotificationsNeedPermission =>
      'Horario guardado. Debes activar las notificaciones para recibir avisos.';

  @override
  String get scheduleNotificationsBlocked =>
      'Horario guardado. Activa las notificaciones en la configuración del dispositivo para recibir avisos.';

  @override
  String get scheduleNotificationsUnavailable =>
      'Horario guardado. Los avisos no están disponibles en este dispositivo.';

  @override
  String get scheduleInactiveMedicationError =>
      'Activa este medicamento antes de programar recordatorios.';

  @override
  String get scheduleMissingTimeError =>
      'Elige al menos un horario de recordatorio.';

  @override
  String get scheduleDuplicateTimeError => 'Este horario ya está seleccionado.';

  @override
  String get scheduleTooManyTimesError => 'Usa cuatro horarios o menos.';

  @override
  String get scheduleInvalidEndDateError =>
      'Elige una fecha final en o después de la primera fecha de recordatorio.';

  @override
  String get todayDueNowTitle => 'Toca ahora';

  @override
  String get todayUpcomingTitle => 'Más tarde';

  @override
  String get todayMissedTitle => 'Pendientes';

  @override
  String get todayHandledTitle => 'Hechos hoy';

  @override
  String get todayClearTitle => 'El resto del día está libre';

  @override
  String get todayClearBody =>
      'No hay más recordatorios de medicamentos que necesiten atención hoy.';

  @override
  String get todayNoMedicationsTitle => 'Todavía no hay medicamentos guardados';

  @override
  String get todayNoMedicationsBody =>
      'Agrega tu primer medicamento para poder configurar recordatorios cuando quieras.';

  @override
  String get todayNoActiveMedicationsTitle =>
      'No hay medicamentos activos ahora';

  @override
  String get todayNoActiveMedicationsBody =>
      'Tus medicamentos guardados están inactivos, así que no aparecerán como pendientes hoy.';

  @override
  String get todayNoSchedulesTitle =>
      'Todavía no hay recordatorios programados';

  @override
  String get todayNoSchedulesBody =>
      'Programa un recordatorio para un medicamento activo y lo verás aquí hoy.';

  @override
  String get todayManageMedications => 'Administrar medicamentos';

  @override
  String get todayMarkHandled => 'Marcar hecho';

  @override
  String todayReminderTime(Object time) {
    return '$time';
  }

  @override
  String get dueReminderTitle => 'Recordatorio de medicamento';

  @override
  String dueReminderScheduledTime(Object time) {
    return 'Programado para $time';
  }

  @override
  String get todayReminderStatusDueNow => 'Toca ahora';

  @override
  String get todayReminderStatusUpcoming => 'Próximo';

  @override
  String get todayReminderStatusMissed => 'Pendiente';

  @override
  String get todayReminderStatusHandled => 'Hecho';

  @override
  String todayReminderSemantics(Object medication, Object time, Object status) {
    return '$medication, $time, $status';
  }

  @override
  String todayReminderSemanticsWithDose(
    Object medication,
    Object dose,
    Object time,
    Object status,
  ) {
    return '$medication, $dose, $time, $status';
  }

  @override
  String todayMarkHandledSemantics(Object medication, Object time) {
    return 'Marcar $medication de las $time como hecho';
  }

  @override
  String get todayNotificationGuidance =>
      'Los avisos pueden necesitar permiso de notificaciones, pero el horario de hoy igual se muestra aquí.';

  @override
  String get dueReminderStateUnresolved => 'Este recordatorio está pendiente.';

  @override
  String get dueReminderStateTaken => 'Marcado como tomado.';

  @override
  String get dueReminderStateSkipped => 'Omitido.';

  @override
  String get dueReminderStateLater => 'Te recordaremos de nuevo más tarde.';

  @override
  String get dueReminderTakenAction => 'Tomado';

  @override
  String get dueReminderSkipAction => 'Omitir';

  @override
  String get dueReminderLaterAction => 'Recordar después';

  @override
  String get dueReminderPermissionNeeded =>
      'Debes activar las notificaciones para recibir avisos. Puedes atender este recordatorio aquí.';

  @override
  String get dueReminderPermissionBlocked =>
      'Activa las notificaciones en la configuración del dispositivo. Puedes atender este recordatorio aquí.';

  @override
  String get dueReminderPermissionUnavailable =>
      'Los avisos no están disponibles en este dispositivo. Puedes atender este recordatorio aquí.';

  @override
  String get dueReminderBannerTitle => 'Recordatorios pendientes';

  @override
  String dueReminderBannerItem(Object name) {
    return '$name está pendiente';
  }

  @override
  String dueReminderBannerSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recordatorios pendientes',
      one: '1 recordatorio pendiente',
    );
    return '$_temp0';
  }

  @override
  String get reminderHandlingSettingsTitle => 'Manejo de recordatorios';

  @override
  String get reminderHandlingIntervalLabel => 'Recordar después de';
}
