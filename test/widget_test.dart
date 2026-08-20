import 'package:flutter_test/flutter_test.dart';
import 'package:engezzha/features/planner/models/entry_kind.dart';
import 'package:engezzha/features/planner/models/planner_entry.dart';

void main() {
  test('habit applies from its start date onward', () {
    final habit = PlannerEntry(
      title: 'Drink water',
      notes: '',
      kind: EntryKind.habit,
      emoji: '💧',
      date: DateTime(2026, 8, 20),
    );

    expect(habit.appliesTo(DateTime(2026, 8, 19)), isFalse);
    expect(habit.appliesTo(DateTime(2026, 8, 20)), isTrue);
    expect(habit.appliesTo(DateTime(2026, 8, 21)), isTrue);
  });

  test('completion is stored per day', () {
    final entry = PlannerEntry(
      title: 'Read',
      notes: '',
      kind: EntryKind.task,
      emoji: '📚',
      date: DateTime(2026, 8, 21),
      completedDates: const ['2026-08-21'],
    );

    expect(entry.isCompletedFor(DateTime(2026, 8, 21)), isTrue);
    expect(entry.isCompletedFor(DateTime(2026, 8, 22)), isFalse);
  });
}
