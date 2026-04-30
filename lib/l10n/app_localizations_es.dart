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
}
