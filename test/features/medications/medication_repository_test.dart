import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/data/local_medication_repository.dart';
import 'package:pill_reminder/features/medications/domain/medication.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalMedicationRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    repository = LocalMedicationRepository(preferences);
  });

  test(
    'saving and reloading a name-only medication defaults to active',
    () async {
      await repository.addMedication(name: '  Morning pill  ');

      final medications = await repository.loadMedications();

      expect(medications, hasLength(1));
      expect(medications.single.name, 'Morning pill');
      expect(medications.single.status, MedicationStatus.active);
    },
  );

  test('preserves entered fields, status, and timestamps', () async {
    final saved = await repository.addMedication(
      name: 'Night pill',
      dosageLabel: '1 tablet',
      notes: 'Take with water',
      status: MedicationStatus.inactive,
    );

    final medications = await repository.loadMedications();
    final reloaded = medications.single;

    expect(reloaded.id, saved.id);
    expect(reloaded.name, 'Night pill');
    expect(reloaded.dosageLabel, '1 tablet');
    expect(reloaded.notes, 'Take with water');
    expect(reloaded.status, MedicationStatus.inactive);
    expect(reloaded.createdAt, saved.createdAt);
    expect(reloaded.updatedAt, saved.updatedAt);
  });

  test('persists inactive status', () async {
    await repository.addMedication(
      name: 'Paused medication',
      status: MedicationStatus.inactive,
    );

    final medications = await repository.loadMedications();

    expect(medications.single.status, MedicationStatus.inactive);
  });
}
